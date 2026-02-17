<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('player_drop_preferences', function (Blueprint $table) {
            $table->id();
            $table->foreignId('player_id')->constrained()->onDelete('cascade');
            $table->foreignId('drop_id')->constrained()->onDelete('cascade');
            $table->integer('priority')->comment('1 = highest priority, 10 = lowest priority');
            $table->timestamps();

            $table->unique(['player_id', 'drop_id']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('player_drop_preferences');
    }
};

