<?php

namespace App\Http\Controllers;

use App\Models\Drop;
use App\Models\PlayerDropPreference;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Session;

class PlayerRedeemRewardsController extends Controller
{
    public function show()
    {
        $player = Session::get('player');

        if (!$player) {
            return redirect()->route('player.login');
        }

        // Calcular pontos totais de check-ins do player
        $totalPoints = $player->checkins()
            ->join('events', 'events.id', '=', 'checkins.event_id')
            ->sum('events.points');

        // Calcular score de recompensa (power / 100000 * pontos)
        $rewardScore = ($player->power / 100000) * $totalPoints;

        // Buscar todas as drops disponíveis
        $drops = Drop::all();

        // Buscar preferências do player
        $preferences = PlayerDropPreference::where('player_id', $player->id)
            ->orderBy('priority')
            ->get();

        return view('player.redeem-rewards', [
            'player' => $player,
            'totalPoints' => $totalPoints,
            'rewardScore' => round($rewardScore, 2),
            'drops' => $drops,
            'preferences' => $preferences,
        ]);
    }

    public function updatePreferences(Request $request)
    {
        $player = Session::get('player');

        if (!$player) {
            return redirect()->route('player.login');
        }

        $validated = $request->validate([
            'preferences' => ['array', 'max:10'],
            'preferences.*' => ['integer', 'exists:drops,id'],
        ]);

        // Deletar preferências antigas
        PlayerDropPreference::where('player_id', $player->id)->delete();

        // Criar novas preferências
        if (isset($validated['preferences']) && is_array($validated['preferences'])) {
            foreach ($validated['preferences'] as $priority => $dropId) {
                PlayerDropPreference::create([
                    'player_id' => $player->id,
                    'drop_id' => $dropId,
                    'priority' => $priority + 1, // Priority começa em 1
                ]);
            }
        }

        return redirect()->route('player.redeem-rewards')->with('success', 'Preferences updated successfully!');
    }
}

