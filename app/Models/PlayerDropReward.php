<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class PlayerDropReward extends Model
{
    protected $fillable = [
        'player_id',
        'drop_id',
        'sent_at',
    ];

    protected $casts = [
        'sent_at' => 'datetime',
    ];

    public function player(): BelongsTo
    {
        return $this->belongsTo(Player::class);
    }

    public function drop(): BelongsTo
    {
        return $this->belongsTo(Drop::class);
    }
}
