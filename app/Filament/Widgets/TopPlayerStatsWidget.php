<?php

namespace App\Filament\Widgets;

use App\Models\Player;
use Filament\Widgets\StatsOverviewWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class TopPlayerStatsWidget extends StatsOverviewWidget
{
    protected function getStats(): array
    {
        $topPlayer = Player::orderBy('power', 'desc')->first();

        return [
            Stat::make('Top Player', $topPlayer?->name ?? 'No players yet')
                ->description('Player with highest power')
                ->descriptionIcon('heroicon-m-trophy')
                ->value(number_format($topPlayer?->power) ?? 0)
                ->color('success'),

            Stat::make('Total Players', Player::count())
                ->description('Registered players')
                ->descriptionIcon('heroicon-m-users')
                ->color('primary'),

            Stat::make('Average Power', number_format(Player::avg('power') ?? 0, 1))
                ->description('Average player power')
                ->descriptionIcon('heroicon-m-bolt')
                ->color('warning'),
        ];
    }
}
