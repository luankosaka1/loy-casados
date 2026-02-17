<x-filament-panels::page>
    <div class="space-y-6">
        <div class="bg-gradient-to-r from-purple-600 to-indigo-600 rounded-lg shadow-lg p-6 text-white">
            <h2 class="text-2xl font-bold mb-2">📦 Send Drops to Players</h2>
            <p class="text-purple-100">Automatically distribute drops to players based on their reward score and drop preferences.</p>
        </div>

        {{ $this->table }}

        <div class="bg-green-50 rounded-lg p-6 border-l-4 border-green-600">
            <h3 class="font-bold text-green-900 mb-2">✅ Distribution Algorithm</h3>
            <ol class="text-green-800 text-sm space-y-2 list-decimal list-inside">
                <li>Players are sorted by their <strong>reward score</strong> (highest first)</li>
                <li>Reward Score = (Power ÷ 100000) × Total Check-in Points</li>
                <li><strong>Redistribution Loop (continues until all drops are distributed):</strong>
                    <ul class="ml-6 mt-1 space-y-1">
                        <li>• For each player (in order of reward score):</li>
                        <li>• Check if player has preferences with available drops</li>
                        <li>• Send the highest priority preference that still has quantity available</li>
                        <li>• If no preferences have available drops, send any available drop</li>
                    </ul>
                </li>
                <li><strong>Automatic Redistribution:</strong>
                    <ul class="ml-6 mt-1 space-y-1">
                        <li>• If drops remain after preference matching, start a new round</li>
                        <li>• Distribute remaining drops to players in order of reward score</li>
                        <li>• Continue until all drops are distributed or no valid distribution exists</li>
                        <li>• Players can receive the same drop multiple times if needed</li>
                    </ul>
                </li>
                <li>Process continues in multiple rounds until all drops are exhausted</li>
            </ol>
        </div>

        <div class="bg-blue-50 rounded-lg p-6 border-l-4 border-blue-600">
            <h3 class="font-bold text-blue-900 mb-2">ℹ️ How it Works</h3>
            <ul class="text-blue-800 text-sm space-y-2">
                <li>✅ Each player has a list of preferred drops ordered by priority</li>
                <li>✅ Higher reward scores receive drops first</li>
                <li>✅ Distribution happens in multiple rounds until all drops are used</li>
                <li>✅ If a drop runs out, the next preference is given instead</li>
                <li>✅ Players can receive the same drop multiple times during redistribution</li>
                <li>✅ Remaining drops are automatically distributed to maintain fairness</li>
                <li>✅ Click "Confirm Send" to start the distribution process</li>
            </ul>
        </div>
    </div>
</x-filament-panels::page>
