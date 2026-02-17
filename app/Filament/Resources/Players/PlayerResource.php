<?php

namespace App\Filament\Resources\Players;

use App\Filament\Resources\Players\Pages\ManagePlayers;
use App\Models\Player;
use BackedEnum;
use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteAction;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Forms\Components\TextInput;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class PlayerResource extends Resource
{
    protected static ?string $model = Player::class;

    protected static string|BackedEnum|null $navigationIcon = Heroicon::OutlinedRectangleStack;

    public static function form(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('name')
                    ->required()
                    ->maxLength(255),
                TextInput::make('power')
                    ->required()
                    ->numeric()
                    ->integer(),
                TextInput::make('discord')
                    ->maxLength(255)
                    ->label('Discord'),
                TextInput::make('password')
                    ->maxLength(255)
                    ->label('Password')
                    ->disabled()
                    ->helperText('Password is auto-generated'),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('name')
                    ->searchable()
                    ->sortable(),
                TextColumn::make('power')
                    ->sortable()
                    ->numeric(),
                TextColumn::make('discord')
                    ->searchable()
                    ->sortable()
                    ->label('Discord'),
                TextColumn::make('password')
                    ->label('Password')
                    ->formatStateUsing(fn ($state) => str_repeat('•', 10))
                    ->copyable()
                    ->copyableState(fn ($record) => $record->password)
                    ->sortable(),
                TextColumn::make('created_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
                TextColumn::make('updated_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                //
            ])
            ->recordActions([
                EditAction::make(),
                DeleteAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }

    public static function getPages(): array
    {
        return [
            'index' => ManagePlayers::route('/'),
        ];
    }
}
