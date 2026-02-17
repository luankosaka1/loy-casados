<?php

namespace App\Filament\Resources\Players\Pages;

use App\Filament\Resources\Players\PlayerResource;
use App\Models\Player;
use Filament\Actions\Action;
use Filament\Actions\CreateAction;
use Filament\Forms\Components\FileUpload;
use Filament\Notifications\Notification;
use Filament\Resources\Pages\ManageRecords;
use Illuminate\Support\Facades\Storage;

class ManagePlayers extends ManageRecords
{
    protected static string $resource = PlayerResource::class;

    protected function getHeaderActions(): array
    {
        return [
            CreateAction::make(),
            Action::make('importCsv')
                ->label('Import CSV')
                ->icon('heroicon-m-arrow-up-tray')
                ->form([
                    FileUpload::make('file')
                        ->label('CSV file')
                        ->required()
                        ->acceptedFileTypes([
                            'text/csv',
                            'text/plain',
                            'application/vnd.ms-excel',
                        ])
                        ->disk('local')
                        ->directory('imports')
                        ->preserveFilenames(),
                ])
                ->action(function (array $data): void {
                    $path = $data['file'] ?? null;

                    if (! $path) {
                        Notification::make()
                            ->title('Import failed')
                            ->body('CSV file not found.')
                            ->danger()
                            ->send();

                        return;
                    }

                    $result = $this->importPlayersFromCsv($path);

                    Notification::make()
                        ->title('Import completed')
                        ->body("Created {$result['created']} and updated {$result['updated']} players. Skipped {$result['skipped']} rows.")
                        ->success()
                        ->send();
                }),
        ];
    }

    private function importPlayersFromCsv(string $path): array
    {
        $created = 0;
        $updated = 0;
        $skipped = 0;

        $fullPath = Storage::disk('local')->path($path);
        $handle = fopen($fullPath, 'r');

        if ($handle === false) {
            return [
                'created' => 0,
                'updated' => 0,
                'skipped' => 0,
            ];
        }

        try {
            $rowIndex = 0;

            while (($row = fgetcsv($handle)) !== false) {
                if ($rowIndex === 0) {
                    $first = strtolower(trim($row[0] ?? ''));
                    $second = strtolower(trim($row[1] ?? ''));

                    if ($first === 'name' && $second === 'power') {
                        $rowIndex++;
                        continue;
                    }
                }

                $name = trim($row[0] ?? '');
                $power = trim($row[1] ?? '');

                if ($name === '' || $power === '') {
                    $skipped++;
                    $rowIndex++;
                    continue;
                }

                $player = Player::updateOrCreate(
                    ['name' => $name],
                    ['power' => (int) $power],
                );

                // Gera password se não existir
                if (empty($player->password)) {
                    $player->password = Player::generatePassword();
                    $player->save();
                }

                if ($player->wasRecentlyCreated) {
                    $created++;
                } else {
                    $updated++;
                }

                $rowIndex++;
            }
        } finally {
            fclose($handle);
            Storage::disk('local')->delete($path);
        }

        return [
            'created' => $created,
            'updated' => $updated,
            'skipped' => $skipped,
        ];
    }
}
