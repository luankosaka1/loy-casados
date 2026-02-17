<?php

namespace App\Filament\Resources\DropResource\Pages;

use App\Filament\Resources\DropResource\DropResource;
use App\Models\Drop;
use Filament\Actions\Action;
use Filament\Actions\CreateAction;
use Filament\Forms\Components\FileUpload;
use Filament\Notifications\Notification;
use Filament\Resources\Pages\ManageRecords;
use Illuminate\Support\Facades\Storage;

class ManageDrops extends ManageRecords
{
    protected static string $resource = DropResource::class;

    protected function getHeaderActions(): array
    {
        return [
            CreateAction::make(),
            Action::make('importCsv')
                ->label('Import CSV')
                ->icon('heroicon-o-arrow-up-tray')
                ->form([
                    FileUpload::make('file')
                        ->label('CSV File')
                        ->acceptedFileTypes(['text/csv', 'text/plain', 'application/csv'])
                        ->required(),
                ])
                ->action(function (array $data): void {
                    $this->importCsv($data['file']);
                }),
        ];
    }

    protected function importCsv(string $filePath): void
    {
        $path = Storage::disk('local')->path($filePath);

        if (!file_exists($path)) {
            Notification::make()
                ->danger()
                ->title('File not found')
                ->send();
            return;
        }

        $file = fopen($path, 'r');
        $isFirstLine = true;
        $imported = 0;

        while (($row = fgetcsv($file)) !== false) {
            // Ignora a primeira linha (cabeçalho)
            if ($isFirstLine) {
                $isFirstLine = false;
                continue;
            }

            // Verifica se tem pelo menos 3 colunas: quantity, name, place
            if (count($row) >= 3 && !empty(trim($row[0]))) {
                Drop::create([
                    'quantity' => (int) trim($row[0]),
                    'name' => trim($row[1]),
                    'place' => trim($row[2]),
                ]);
                $imported++;
            }
        }

        fclose($file);
        Storage::disk('local')->delete($filePath);

        Notification::make()
            ->success()
            ->title("Successfully imported {$imported} drop(s)")
            ->send();
    }
}
