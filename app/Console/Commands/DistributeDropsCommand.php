<?php

namespace App\Console\Commands;

use App\Models\Drop;
use App\Models\Player;
use App\Models\PlayerDropPreference;
use App\Models\PlayerDropReward;
use Illuminate\Console\Command;

class DistributeDropsCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:distribute-drops';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Distribute drops to players based on their reward score and preferences';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $this->info('Starting drop distribution...');

        try {
            // Get all players with necessary relationships
            $allPlayers = Player::with(['dropPreferences.drop', 'dropRewards', 'checkins.event'])
                ->get();

            // Calculate reward score for each player and create sorted list
            $playersWithScores = $allPlayers->map(function ($player) {
                $totalPoints = $player->checkins()
                    ->join('events', 'events.id', '=', 'checkins.event_id')
                    ->sum('events.points');

                return [
                    'player' => $player,
                    'score' => ($player->power / 100000) * $totalPoints,
                ];
            })->sortByDesc('score')->values();

            // Get all drops and their total quantity
            $drops = Drop::all();
            $alreadySentDropIds = PlayerDropReward::query()
                ->distinct()
                ->pluck('drop_id')
                ->all();
            $alreadySentDropIds = array_flip($alreadySentDropIds);

            $dropInventory = [];
            foreach ($drops as $drop) {
                if (isset($alreadySentDropIds[$drop->id])) {
                    $dropInventory[$drop->id] = 0;
                    continue;
                }

                $dropInventory[$drop->id] = $drop->quantity > 0 ? 1 : 0; // quantidade > 1 conta como 1
            }

            $distributedCount = 0;
            $distributionRound = 0;
            $maxRounds = count($allPlayers) + 1;

            $this->info("Found " . count($allPlayers) . " players and " . count($drops) . " drop types.");
            $this->info("Total drop types to distribute: " . array_sum($dropInventory));

            // Continue distributing while there are drops to distribute
            while ($this->hasDropsRemaining($dropInventory) && $distributionRound < $maxRounds) {
                $distributionRound++;
                $roundDistributions = 0;

                $this->line("Round {$distributionRound}:");

                // For each player in order of reward score
                foreach ($playersWithScores as $playerData) {
                    $player = $playerData['player'];

                    // Se o player tem score 0 ou menor (sem pontos de check-in), pular
                    if ($playerData['score'] <= 0) {
                        continue;
                    }

                    // Check if there are still drops available
                    if (!$this->hasDropsRemaining($dropInventory)) {
                        break;
                    }

                    // Procurar por um drop disponível que o player ainda não tenha recebido
                    foreach ($drops as $drop) {
                        if ($dropInventory[$drop->id] > 0) {
                            // Verificar se o drop já foi cadastrado para este player
                            $existingReward = PlayerDropReward::where('player_id', $player->id)
                                ->where('drop_id', $drop->id)
                                ->first();

                            if (!$existingReward) {
                                // Send only 1 unit of the drop to the player
                                PlayerDropReward::create([
                                    'player_id' => $player->id,
                                    'drop_id' => $drop->id,
                                    'sent_at' => now(),
                                ]);

                                // Decrement inventory (only 1 unit)
                                $dropInventory[$drop->id]--;
                                $distributedCount++;
                                $roundDistributions++;

                                $this->line("  ✓ {$player->name} received {$drop->name}");

                                // Exit drop loop after distributing a drop
                                break;
                            }
                        }
                    }
                }


                // If no distributions happened, exit loop
                if ($roundDistributions === 0) {
                    break;
                }
            }

            $remainingDrops = array_sum($dropInventory);
            $this->newLine();
            $this->info("Distribution completed!");
            $this->info("Distributed: {$distributedCount} drop type(s)");
            $this->info("Remaining: {$remainingDrops} drop type(s)");

            PlayerDropPreference::query()->delete();
            $this->info("Cleared player_drop_preferences.");
        } catch (\Exception $e) {
            $this->error('Error: ' . $e->getMessage());
            return 1;
        }

        return 0;
    }

    /**
     * Check if there are drops remaining to distribute
     */
    private function hasDropsRemaining(array $dropInventory): bool
    {
        return array_sum($dropInventory) > 0;
    }
}
