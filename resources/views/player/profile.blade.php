<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Player Profile - LoY CASADOS</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gradient-to-br from-purple-900 via-purple-800 to-indigo-900 min-h-screen">
    <!-- Navigation Bar -->
    <nav class="bg-black/30 backdrop-blur-md border-b border-purple-500/30">
        <div class="max-w-6xl mx-auto px-6 py-4 flex justify-between items-center">
            <div class="text-white">
                <h1 class="text-3xl font-bold">LoY <span class="text-purple-400">CASADOS</span></h1>
                <p class="text-purple-300 text-sm">Player Dashboard</p>
            </div>
            <div class="flex gap-4">
                <a
                    href="{{ route('player.redeem-rewards') }}"
                    class="bg-gradient-to-r from-yellow-600 to-orange-600 hover:from-yellow-700 hover:to-orange-700 text-white font-bold py-2 px-6 rounded-lg transition"
                >
                    🎁 Redeem the Rewards
                </a>
                <form method="POST" action="{{ route('player.logout') }}" class="inline">
                    @csrf
                    <button
                        type="submit"
                        class="bg-red-600 hover:bg-red-700 text-white font-bold py-2 px-6 rounded-lg transition"
                    >
                        Logout
                    </button>
                </form>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="max-w-6xl mx-auto px-6 py-12">
        <!-- Welcome Card -->
        <div class="bg-white rounded-lg shadow-2xl p-8 mb-8">
            <h2 class="text-4xl font-bold text-purple-900 mb-2">
                Welcome, {{ $player->name }}! 👋
            </h2>
            <p class="text-gray-600">
                Here's your player profile and statistics.
            </p>
        </div>

        <!-- Profile Cards Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
            <!-- Name Card -->
            <div class="bg-white rounded-lg shadow-lg p-6 border-l-4 border-purple-600">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="text-gray-700 font-semibold text-sm uppercase tracking-wide">Name</h3>
                    <span class="text-3xl">👤</span>
                </div>
                <p class="text-3xl font-bold text-purple-900">{{ $player->name }}</p>
            </div>

            <!-- Discord Card -->
            <div class="bg-white rounded-lg shadow-lg p-6 border-l-4 border-indigo-600">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="text-gray-700 font-semibold text-sm uppercase tracking-wide">Discord</h3>
                    <span class="text-3xl">🎮</span>
                </div>
                <p class="text-2xl font-bold text-indigo-900">{{ $player->discord }}</p>
            </div>

            <!-- Power Card -->
            <div class="bg-white rounded-lg shadow-lg p-6 border-l-4 border-pink-600">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="text-gray-700 font-semibold text-sm uppercase tracking-wide">Power</h3>
                    <span class="text-3xl">⚡</span>
                </div>
                <p class="text-3xl font-bold text-pink-900">{{ number_format($player->power) }}</p>
            </div>

            <!-- Password Card (Masked) -->
            <div class="bg-white rounded-lg shadow-lg p-6 border-l-4 border-green-600">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="text-gray-700 font-semibold text-sm uppercase tracking-wide">Password</h3>
                    <span class="text-3xl">🔐</span>
                </div>
                <div class="flex items-center justify-between">
                    <p class="text-2xl font-bold text-green-900 tracking-widest">••••••••••</p>
                    <button
                        onclick="copyToClipboard('{{ $player->password }}')"
                        class="ml-4 bg-green-600 hover:bg-green-700 text-white py-2 px-4 rounded transition text-sm"
                    >
                        Copy
                    </button>
                </div>
            </div>

            <!-- Member Since Card -->
            <div class="bg-white rounded-lg shadow-lg p-6 border-l-4 border-blue-600">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="text-gray-700 font-semibold text-sm uppercase tracking-wide">Member Since</h3>
                    <span class="text-3xl">📅</span>
                </div>
                <p class="text-lg font-bold text-blue-900">
                    {{ $player->created_at->format('M d, Y') }}
                </p>
                <p class="text-sm text-gray-600 mt-2">
                    {{ $player->created_at->diffForHumans() }}
                </p>
            </div>

            <!-- Last Updated Card -->
            <div class="bg-white rounded-lg shadow-lg p-6 border-l-4 border-yellow-600">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="text-gray-700 font-semibold text-sm uppercase tracking-wide">Last Updated</h3>
                    <span class="text-3xl">🔄</span>
                </div>
                <p class="text-lg font-bold text-yellow-900">
                    {{ $player->updated_at->format('M d, Y H:i') }}
                </p>
                <p class="text-sm text-gray-600 mt-2">
                    {{ $player->updated_at->diffForHumans() }}
                </p>
            </div>
        </div>

        <!-- Check-ins Section -->
        <div class="bg-white rounded-lg shadow-lg p-8">
            <h3 class="text-2xl font-bold text-purple-900 mb-6">📊 Check-ins</h3>
            @if ($player->checkins && count($player->checkins) > 0)
                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead>
                            <tr class="bg-purple-50 border-b-2 border-purple-200">
                                <th class="px-6 py-3 text-left text-sm font-semibold text-purple-900">Event</th>
                                <th class="px-6 py-3 text-left text-sm font-semibold text-purple-900">Points</th>
                                <th class="px-6 py-3 text-left text-sm font-semibold text-purple-900">Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($player->checkins as $checkin)
                                <tr class="border-b hover:bg-purple-50 transition">
                                    <td class="px-6 py-4 text-gray-800">{{ $checkin->event->name ?? 'N/A' }}</td>
                                    <td class="px-6 py-4 text-purple-900 font-semibold">
                                        {{ $checkin->event->points ?? '0' }}
                                    </td>
                                    <td class="px-6 py-4 text-gray-600">
                                        {{ $checkin->checked_in_at->format('M d, Y H:i') }}
                                    </td>
                                </tr>
                            @endforeach
                        </tbody>
                    </table>
                </div>
            @else
                <div class="bg-purple-50 rounded-lg p-8 text-center">
                    <p class="text-gray-600 text-lg">No check-ins yet</p>
                    <p class="text-gray-500 text-sm mt-2">You haven't checked in to any events</p>
                </div>
            @endif
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-black/30 backdrop-blur-md border-t border-purple-500/30 mt-12">
        <div class="max-w-6xl mx-auto px-6 py-6 text-center text-purple-300 text-sm">
            <p>&copy; 2026 LoY CASADOS. All rights reserved.</p>
        </div>
    </footer>

    <script>
        function copyToClipboard(text) {
            navigator.clipboard.writeText(text).then(() => {
                alert('Password copied to clipboard!');
            }).catch(err => {
                console.error('Failed to copy:', err);
            });
        }
    </script>
</body>
</html>

