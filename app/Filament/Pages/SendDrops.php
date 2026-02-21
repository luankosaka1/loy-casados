<?php

namespace App\Filament\Pages;

use App\Models\Drop;
use App\Models\Player;
use App\Models\PlayerDropPreference;
use App\Models\PlayerDropReward;
use BackedEnum;
use Filament\Actions\Action;
use Filament\Forms\Components\DatePicker;
use Filament\Notifications\Notification;
use Filament\Pages\Page;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Concerns\InteractsWithTable;
use Filament\Tables\Contracts\HasTable;
use Filament\Tables\Table;
use UnitEnum;

class SendDrops extends Page implements HasTable
{
    use InteractsWithTable;

    protected static string|BackedEnum|null $navigationIcon = 'heroicon-o-gift';
    protected static ?string $navigationLabel = 'Send Drops';
    protected static ?string $title = 'Send Drops to Players';
    protected static ?string $slug = 'send-drops';

    protected string $view = 'filament.pages.send-drops';

    public ?\DateTime $startDate = null;
    public ?\DateTime $endDate = null;

    public function table(Table $table): Table
    {
        return $table
            ->query(Player::query())
            ->columns([
                TextColumn::make('name')
                    ->label('Player Name')
                    ->searchable()
                    ->sortable(),
                TextColumn::make('discord')
                    ->label('Discord')
                    ->searchable()
                    ->sortable(),
                TextColumn::make('power')
                    ->label('Power')
                    ->numeric()
                    ->sortable(),
                TextColumn::make('dropPreferences.drop.name')
                    ->label('Preferred Drops')
                    ->getStateUsing(function ($record) {
                        $drops = $record->dropPreferences()
                            ->with('drop')
                            ->orderBy('priority')
                            ->get();

                        if ($drops->isEmpty()) {
                            return 'No preferences set';
                        }

                        return $drops->map(fn($pref) =>
                            "#{$pref->priority} " . $pref->drop->name
                        )->join(', ');
                    }),
            ])
            ->filters([
                //
            ]);
    }

    protected function getHeaderActions(): array
    {
        return [
            Action::make('confirmSend')
                ->label('Confirm Send')
                ->icon('heroicon-o-paper-airplane')
                ->color('success')
                ->form([
                    DatePicker::make('startDate')
                        ->label('Start Date')
                        ->default(fn () => now()->subDays(7))
                        ->nullable(),
                    DatePicker::make('endDate')
                        ->label('End Date')
                        ->default(fn () => now())
                        ->nullable(),
                ])
                ->action(function (array $data) {
                    $this->startDate = $data['startDate']
                        ? \Carbon\Carbon::parse($data['startDate'])->startOfDay()
                        : null;
                    $this->endDate = $data['endDate']
                        ? \Carbon\Carbon::parse($data['endDate'])->endOfDay()
                        : null;
                    $this->distributeDrops();
                })
                ->modalHeading('Distribute Drops to Players')
                ->modalDescription('Configure the date range for calculating player scores and then distribute drops based on their reward score and drop preferences.')
                ->modalSubmitActionLabel('Distribute'),
        ];
    }

    protected function distributeDrops(): void
    {
        try {
            // Obter todos os players com suas informações necessárias
            $allPlayers = Player::with(['dropPreferences.drop', 'dropRewards', 'checkins.event'])
                ->get();

            // Calcular reward score para cada player e criar lista ordenada
            $playersWithScores = $allPlayers->map(function ($player) {
                $query = $player->checkins()
                    ->join('events', 'events.id', '=', 'checkins.event_id');

                if ($this->startDate && $this->endDate) {
                    $query->whereBetween('checkins.created_at', [$this->startDate, $this->endDate]);
                } elseif ($this->startDate) {
                    $query->where('checkins.created_at', '>=', $this->startDate);
                } elseif ($this->endDate) {
                    $query->where('checkins.created_at', '<=', $this->endDate);
                }

                $totalPoints = $query->sum('events.points');

                return [
                    'player' => $player,
                    'score' => ($player->power / 100000) * $totalPoints,
                ];
            })->sortByDesc('score')->values();

            $drops = Drop::all();
            $alreadySentDropIds = PlayerDropReward::query()
                ->distinct()
                ->pluck('drop_id')
                ->all();
            $alreadySentDropIds = array_flip($alreadySentDropIds);

            $dropInventory = [];
            foreach ($drops as $drop) {
                if (isset($alreadySentDropIds[$drop->id])) {
                    $dropInventory[$drop->id] = 0;
                    continue;
                }

                $dropInventory[$drop->id] = $drop->quantity > 0 ? 1 : 0; // quantidade > 1 conta como 1
            }

            $distributedCount = 0;
            $distributionRound = 0;
            $maxRounds = count($allPlayers) + 1; // Limitar rodadas para evitar loop infinito

            // Continuar distribuindo enquanto houver drops para distribuir
            while ($this->hasDropsRemaining($dropInventory) && $distributionRound < $maxRounds) {
                $distributionRound++;
                $roundDistributions = 0;

                // Para cada player em ordem de reward score
                foreach ($playersWithScores as $playerData) {
                    $player = $playerData['player'];

                    // Se o player tem score 0 ou menor (sem pontos de check-in), pular
                    if ($playerData['score'] <= 0) {
                        continue;
                    }

                    // Verificar se ainda há drops disponíveis
                    if (!$this->hasDropsRemaining($dropInventory)) {
                        break;
                    }

                    // Procurar por um drop disponível que o player ainda não tenha recebido
                    foreach ($drops as $drop) {
                        if ($dropInventory[$drop->id] > 0) {
                            // Verificar se o drop já foi cadastrado para este player
                            $existingReward = PlayerDropReward::where('player_id', $player->id)
                                ->where('drop_id', $drop->id)
                                ->first();

                            if (!$existingReward) {
                                // Enviar apenas 1 unidade do drop para o player
                                PlayerDropReward::create([
                                    'player_id' => $player->id,
                                    'drop_id' => $drop->id,
                                    'sent_at' => now(),
                                ]);

                                // Decrementar o inventário (apenas 1 unidade)
                                $dropInventory[$drop->id]--;
                                $distributedCount++;
                                $roundDistributions++;

                                // Sair do loop de drops após distribuir um drop
                                break;
                            }
                        }
                    }
                }

                // Se nenhuma distribuição aconteceu nesta rodada, sair do loop
                if ($roundDistributions === 0) {
                    break;
                }
            }

            $remainingDrops = array_sum($dropInventory);
            $successMessage = "Distributed {$distributedCount} drop type(s) to player(s).";
            if ($remainingDrops > 0) {
                $successMessage .= " {$remainingDrops} drop type(s) remain(s) undistributed (not enough eligible players).";
            } else {
                $successMessage .= " All available drop types have been distributed!";
            }

            Notification::make()
                ->success()
                ->title('Drops Distributed Successfully!')
                ->body($successMessage)
                ->send();

            PlayerDropPreference::query()->delete();
        } catch (\Exception $e) {
            Notification::make()
                ->danger()
                ->title('Error Distributing Drops')
                ->body($e->getMessage())
                ->send();
        }
    }

    /**
     * Verificar se ainda há drops a distribuir
     */
    private function hasDropsRemaining(array $dropInventory): bool
    {
        return array_sum($dropInventory) > 0;
    }
}
