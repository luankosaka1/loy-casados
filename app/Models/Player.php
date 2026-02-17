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
        'password',
    ];

    protected static function booted(): void
    {
        static::creating(function ($model) {
            if (empty($model->password)) {
                $model->password = self::generatePassword();
            }
        });

        static::updating(function ($model) {
            if (empty($model->password)) {
                $model->password = self::generatePassword();
            }
        });
    }

    public static function generatePassword(): string
    {
        return substr(str_shuffle('0123456789'), 0, 10);
    }

    public function checkins(): HasMany
    {
        return $this->hasMany(Checkin::class);
    }

    public function dropPreferences(): HasMany
    {
        return $this->hasMany(PlayerDropPreference::class)->orderBy('priority');
    }

    public function dropRewards(): HasMany
    {
        return $this->hasMany(PlayerDropReward::class);
    }
}
