<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Event extends Model
{
    protected $fillable = [
        'name',
        'points',
    ];

    protected $casts = [
        'points' => 'float',
    ];

    public function checkins(): HasMany
    {
        return $this->hasMany(Checkin::class);
    }
}
