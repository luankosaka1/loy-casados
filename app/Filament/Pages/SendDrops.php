<?php

namespace App\Filament\Pages;

use App\Models\Drop;
use App\Models\Player;
use App\Models\PlayerDropPreference;
use BackedEnum;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Concerns\InteractsWithForms;
use Filament\Forms\Contracts\HasForms;
use Filament\Notifications\Notification;
use Filament\Pages\Page;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Concerns\InteractsWithTable;
use Filament\Tables\Contracts\HasTable;
use Filament\Tables\Table;
use UnitEnum;

class SendDrops extends Page implements HasTable, HasForms
{
    use InteractsWithTable;
    use InteractsWithForms;

    protected static string|BackedEnum|null $navigationIcon = 'heroicon-o-gift';
    protected static ?string $navigationLabel = 'Send Drops';
    protected static ?string $title = 'Send Drops to Players';
    protected static ?string $slug = 'send-drops';

    protected string $view = 'filament.pages.send-drops';

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
}
