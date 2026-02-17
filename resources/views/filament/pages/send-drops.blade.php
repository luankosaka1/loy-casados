<x-filament-panels::page>
    <div class="space-y-6">
        <div class="bg-white rounded-lg shadow-lg p-6">
            <h2 class="text-2xl font-bold text-gray-900 mb-2">📦 Send Drops to Players</h2>
            <p class="text-gray-600">View all players and their drop preferences. Send drops based on their priority order.</p>
        </div>

        {{ $this->table }}

        <div class="bg-blue-50 rounded-lg p-6 border-l-4 border-blue-600">
            <h3 class="font-bold text-blue-900 mb-2">ℹ️ How it Works</h3>
            <ul class="text-blue-800 text-sm space-y-2">
                <li>✅ Players set their drop preferences from their profile</li>
                <li>✅ The "Preferred Drops" column shows drops in priority order (#1 = highest)</li>
                <li>✅ Send drops to players based on their preferences</li>
                <li>✅ Track which drops have been sent to each player</li>
            </ul>
        </div>
    </div>
</x-filament-panels::page>
