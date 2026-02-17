<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Session;

class PlayerProfileController extends Controller
{
    public function show()
    {
        $player = Session::get('player');

        if (!$player) {
            return redirect()->route('player.login');
        }

        return view('player.profile', ['player' => $player]);
    }
}

