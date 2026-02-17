<x-filament-panels::page>
    <div class="space-y-6">
        <div class="bg-gradient-to-r from-blue-600 to-cyan-600 rounded-lg shadow-lg p-6 text-white">
            <h2 class="text-2xl font-bold mb-2">📊 Drop Distribution Report</h2>
            <p class="text-blue-100">View all drops that have been distributed to players.</p>
        </div>

        {{ $this->table }}

        <div class="bg-indigo-50 rounded-lg p-6 border-l-4 border-indigo-600">
            <h3 class="font-bold text-indigo-900 mb-2">ℹ️ About This Report</h3>
            <ul class="text-indigo-800 text-sm space-y-2">
                <li>✅ Shows all drop distributions sorted by most recent first</li>
                <li>✅ Each row represents a single drop sent to a player</li>
                <li>✅ The same player-drop combination can appear multiple times</li>
                <li>✅ Use search to find distributions for specific players or drops</li>
                <li>✅ Filter by date range to see recent distributions</li>
            </ul>
        </div>

        <div class="bg-green-50 rounded-lg p-6 border-l-4 border-green-600">
            <h3 class="font-bold text-green-900 mb-2">📈 Statistics</h3>
            <div class="grid grid-cols-3 gap-4 mt-4">
                <div class="bg-white p-4 rounded border border-green-200">
                    <p class="text-green-600 text-sm font-semibold">Total Distributed</p>
                    <p class="text-2xl font-bold text-green-900">{{ $this->getTableRecords()->count() }}</p>
                </div>
            </div>
        </div>
    </div>
</x-filament-panels::page>

