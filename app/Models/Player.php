<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Player extends Model
{
    protected $fillable = [
        'name',
        'power',
        'discord',
    ];

    public function checkins(): HasMany
    {
        return $this->hasMany(Checkin::class);
    }
}
