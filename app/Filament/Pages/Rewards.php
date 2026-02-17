<?php

namespace App\Filament\Pages;

use App\Models\Player;
use BackedEnum;
use Filament\Forms\Components\DatePicker;
use Filament\Pages\Page;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Concerns\InteractsWithTable;
use Filament\Tables\Contracts\HasTable;
use Filament\Tables\Table;
use Filament\Tables\Filters\Filter;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Facades\DB;
use UnitEnum;

class Rewards extends Page implements HasTable
{
    use InteractsWithTable;

    protected static string|BackedEnum|null $navigationIcon = 'heroicon-m-gift';
    protected static ?string $navigationLabel = 'Rewards';
    protected static string|UnitEnum|null $navigationGroup = 'Rewards';
    protected static ?string $title = 'Rewards';
    protected static ?string $slug = 'rewards';
    protected static ?int $navigationSort = 1;

    protected string $view = 'filament.pages.rewards';

    public function table(Table $table): Table
    {
        return $table
            ->query($this->getPlayerRedemptionQuery())
            ->columns([
                TextColumn::make('player_name')
                    ->label('Player')
                    ->sortable()
                    ->searchable(),
                TextColumn::make('points_sum')
                    ->label('Checkin Points')
                    ->numeric()
                    ->sortable(),
                TextColumn::make('power')
                    ->label('Power')
                    ->numeric()
                    ->sortable(),
                TextColumn::make('redemption_score')
                    ->label('Points')
                    ->numeric()
                    ->sortable(),
            ])
            ->filters([
                Filter::make('checkin_period')
                    ->form([
                        DatePicker::make('from')
                            ->label('Data inicial')
                            ->default(fn (): string => now()->startOfWeek()->toDateString()),
                        DatePicker::make('until')
                            ->label('Data final')
                            ->default(fn (): string => now()->endOfWeek()->toDateString()),
                    ])
                    ->default(true)
                    ->query(function (Builder $query, array $data): Builder {
                        return $query
                            ->when(
                                $data['from'] ?? null,
                                fn (Builder $query, string $date): Builder => $query->whereDate('checkins.checked_in_at', '>=', $date)
                            )
                            ->when(
                                $data['until'] ?? null,
                                fn (Builder $query, string $date): Builder => $query->whereDate('checkins.checked_in_at', '<=', $date)
                            );
                    }),
            ])
            ->defaultSort('redemption_score', 'desc');
    }

    private function getPlayerRedemptionQuery(): Builder
    {
        return Player::query()
            ->leftJoin('checkins', 'checkins.player_id', '=', 'players.id')
            ->leftJoin('events', 'events.id', '=', 'checkins.event_id')
            ->select([
                'players.id as id',
                'players.id as player_id',
                'players.name as player_name',
                'players.power as power',
            ])
            ->selectRaw('coalesce(sum(events.points), 0) as points_sum')
            ->selectRaw('round((players.power / 100000) * coalesce(sum(events.points), 0), 2) as redemption_score')
            ->groupBy('players.id', 'players.name', 'players.power');
    }
}
