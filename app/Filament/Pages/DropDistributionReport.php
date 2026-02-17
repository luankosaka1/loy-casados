<?php

namespace App\Filament\Pages;

use App\Models\PlayerDropReward;
use BackedEnum;
use Filament\Forms\Components\DatePicker;
use Filament\Pages\Page;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Concerns\InteractsWithTable;
use Filament\Tables\Contracts\HasTable;
use Filament\Tables\Filters\Filter;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use UnitEnum;

class DropDistributionReport extends Page implements HasTable
{
    use InteractsWithTable;

    protected static string|BackedEnum|null $navigationIcon = 'heroicon-o-chart-bar';
    protected static ?string $navigationLabel = 'Distribution Report';
    protected static string|UnitEnum|null $navigationGroup = 'Rewards';
    protected static ?string $title = 'Drop Distribution Report';
    protected static ?string $slug = 'drop-distribution-report';
    protected static ?int $navigationSort = 4;

    protected string $view = 'filament.pages.drop-distribution-report';

    public function table(Table $table): Table
    {
        return $table
            ->query(PlayerDropReward::query()
                ->with(['player', 'drop'])
                ->orderByDesc('sent_at'))
            ->columns([
                TextColumn::make('player.name')
                    ->label('Player')
                    ->searchable()
                    ->sortable(),
                TextColumn::make('drop.name')
                    ->label('Drop')
                    ->searchable()
                    ->sortable(),
                TextColumn::make('drop.place')
                    ->label('Location')
                    ->searchable(),
                TextColumn::make('sent_at')
                    ->label('Received At')
                    ->dateTime()
                    ->sortable(),
            ])
            ->filters([
                Filter::make('received_period')
                    ->form([
                        DatePicker::make('from')
                            ->label('Data inicial'),
                        DatePicker::make('until')
                            ->label('Data final'),
                    ])
                    ->query(function (Builder $query, array $data): Builder {
                        return $query
                            ->when(
                                $data['from'] ?? null,
                                fn (Builder $query, string $date): Builder => $query->whereDate('sent_at', '>=', $date)
                            )
                            ->when(
                                $data['until'] ?? null,
                                fn (Builder $query, string $date): Builder => $query->whereDate('sent_at', '<=', $date)
                            );
                    }),
            ])
            ->defaultSort('sent_at', 'desc');
    }
}

