<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\Player;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Session;

class PlayerLoginController extends Controller
{
    public function showLoginForm()
    {
        return view('auth.player-login');
    }

    public function login(Request $request)
    {
        $validated = $request->validate([
            'discord' => ['required', 'string'],
            'password' => ['required', 'string'],
        ]);

        $player = Player::where('discord', $validated['discord'])
            ->where('password', $validated['password'])
            ->first();

        if (!$player) {
            return back()
                ->withErrors([
                    'discord' => 'The provided credentials do not match our records.',
                ])
                ->onlyInput('discord');
        }

        Session::put('player_id', $player->id);
        Session::put('player', $player);

        return redirect()->route('player.profile');
    }

    public function logout(Request $request)
    {
        Session::forget('player_id');
        Session::forget('player');

        return redirect()->route('player.login');
    }
}
