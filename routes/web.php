<?php

use App\Http\Controllers\Auth\PlayerLoginController;
use App\Http\Controllers\PlayerProfileController;
use App\Http\Controllers\PlayerRedeemRewardsController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

// Rotas de autenticação de Players (sem middleware)
Route::prefix('player')->name('player.')->group(function () {
    Route::get('/login', [PlayerLoginController::class, 'showLoginForm'])->name('login');
    Route::post('/login', [PlayerLoginController::class, 'login'])->name('login.submit');
});

// Rotas protegidas de Players (com middleware)
Route::prefix('player')->name('player.')->middleware('player.auth')->group(function () {
    Route::get('/profile', [PlayerProfileController::class, 'show'])->name('profile');
    Route::get('/redeem-rewards', [PlayerRedeemRewardsController::class, 'show'])->name('redeem-rewards');
    Route::post('/redeem-rewards/preferences', [PlayerRedeemRewardsController::class, 'updatePreferences'])->name('redeem-rewards.update');
    Route::post('/logout', [PlayerLoginController::class, 'logout'])->name('logout');
});

