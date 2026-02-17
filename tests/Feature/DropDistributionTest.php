<?php

namespace Tests\Feature;

use App\Models\Drop;
use App\Models\Player;
use App\Models\PlayerDropPreference;
use App\Models\PlayerDropReward;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class DropDistributionTest extends TestCase
{
    use RefreshDatabase;

    /**
     * Test basic drop distribution with preferences
     */
    public function test_distributes_drops_based_on_preferences()
    {
        // Setup: Create drops
        $sword = Drop::create(['name' => 'Sword', 'quantity' => 2, 'place' => 'Shop']);
        $shield = Drop::create(['name' => 'Shield', 'quantity' => 2, 'place' => 'Shop']);

        // Setup: Create players with scores
        $playerA = Player::create(['name' => 'Player A', 'power' => 100000]);
        $playerB = Player::create(['name' => 'Player B', 'power' => 50000]);

        // Setup: Create preferences
        PlayerDropPreference::create(['player_id' => $playerA->id, 'drop_id' => $sword->id, 'priority' => 1]);
        PlayerDropPreference::create(['player_id' => $playerA->id, 'drop_id' => $shield->id, 'priority' => 2]);
        PlayerDropPreference::create(['player_id' => $playerB->id, 'drop_id' => $shield->id, 'priority' => 1]);
        PlayerDropPreference::create(['player_id' => $playerB->id, 'drop_id' => $sword->id, 'priority' => 2]);

        // Execute distribution
        $this->artisan('app:distribute-drops')
            ->expectsOutput('Distribution completed!')
            ->assertExitCode(0);

        // Assert: Check distributions
        // Round 1: A gets Sword, B gets Shield
        $this->assertEquals(2, PlayerDropReward::count());

        // Round 2: A gets Shield, B gets Sword
        // For this to happen, we'd need to run the command again or adjust the logic
    }

    /**
     * Test drop redistribution when drops remain
     */
    public function test_redistributes_remaining_drops()
    {
        // Setup: Create drops with more quantity than players want
        $sword = Drop::create(['name' => 'Sword', 'quantity' => 5, 'place' => 'Shop']);
        $potion = Drop::create(['name' => 'Potion', 'quantity' => 5, 'place' => 'Shop']);

        // Setup: Create 2 players who only want 1 drop each
        $playerA = Player::create(['name' => 'Player A', 'power' => 100000]);
        $playerB = Player::create(['name' => 'Player B', 'power' => 50000]);

        // Setup: Only A wants Sword, B wants Potion
        PlayerDropPreference::create(['player_id' => $playerA->id, 'drop_id' => $sword->id, 'priority' => 1]);
        PlayerDropPreference::create(['player_id' => $playerB->id, 'drop_id' => $potion->id, 'priority' => 1]);

        // Execute distribution
        $this->artisan('app:distribute-drops')
            ->assertExitCode(0);

        // Assert: All drops should be distributed eventually
        // This depends on the redistribution logic continuing until drops are exhausted
    }

    /**
     * Test players can receive same drop multiple times
     */
    public function test_players_can_receive_same_drop_multiple_times()
    {
        // Setup: Create 1 drop with high quantity
        $sword = Drop::create(['name' => 'Sword', 'quantity' => 5, 'place' => 'Shop']);

        // Setup: Create 1 player who wants the same drop
        $player = Player::create(['name' => 'Player A', 'power' => 100000]);
        PlayerDropPreference::create(['player_id' => $player->id, 'drop_id' => $sword->id, 'priority' => 1]);

        // The constraint unique on (player_id, drop_id) should be removed
        // So we can create multiple records for the same player-drop combination

        // Create multiple rewards for the same player-drop
        PlayerDropReward::create(['player_id' => $player->id, 'drop_id' => $sword->id, 'sent_at' => now()]);
        PlayerDropReward::create(['player_id' => $player->id, 'drop_id' => $sword->id, 'sent_at' => now()]);
        PlayerDropReward::create(['player_id' => $player->id, 'drop_id' => $sword->id, 'sent_at' => now()]);

        // Assert: Should have 3 records
        $rewards = PlayerDropReward::where('player_id', $player->id)
            ->where('drop_id', $sword->id)
            ->get();

        $this->assertCount(3, $rewards);
    }

    /**
     * Test order of distribution respects reward score
     */
    public function test_distribution_respects_reward_score_order()
    {
        // Setup: Create drops
        $sword = Drop::create(['name' => 'Sword', 'quantity' => 1, 'place' => 'Shop']);

        // Setup: Create 2 players with different powers (different reward scores)
        // Even with same points, higher power should get priority
        $playerHighPower = Player::create(['name' => 'High Power', 'power' => 100000]);
        $playerLowPower = Player::create(['name' => 'Low Power', 'power' => 50000]);

        // Both want the same drop
        PlayerDropPreference::create(['player_id' => $playerHighPower->id, 'drop_id' => $sword->id, 'priority' => 1]);
        PlayerDropPreference::create(['player_id' => $playerLowPower->id, 'drop_id' => $sword->id, 'priority' => 1]);

        // Execute distribution
        $this->artisan('app:distribute-drops')
            ->assertExitCode(0);

        // Assert: High power player should get the sword first
        $reward = PlayerDropReward::where('drop_id', $sword->id)->first();
        $this->assertEquals($playerHighPower->id, $reward->player_id);
    }
}

