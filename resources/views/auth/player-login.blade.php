<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Player Login - LoY CASADOS</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gradient-to-br from-purple-900 via-purple-800 to-indigo-900 min-h-screen flex items-center justify-center">
    <div class="w-full max-w-md">
        <div class="bg-white rounded-lg shadow-2xl p-8">
            <!-- Logo/Title -->
            <div class="text-center mb-8">
                <h1 class="text-4xl font-bold text-purple-900 mb-2">LoY</h1>
                <p class="text-gray-600 text-sm">CASADOS - Player Login</p>
            </div>

            <!-- Errors -->
            @if ($errors->any())
                <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg">
                    @foreach ($errors->all() as $error)
                        <p class="text-red-600 text-sm">{{ $error }}</p>
                    @endforeach
                </div>
            @endif

            <!-- Form -->
            <form method="POST" action="{{ route('player.login.submit') }}">
                @csrf

                <!-- Discord Input -->
                <div class="mb-6">
                    <label for="discord" class="block text-gray-700 font-semibold mb-2">
                        Discord Username
                    </label>
                    <input
                        type="text"
                        id="discord"
                        name="discord"
                        value="{{ old('discord') }}"
                        class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-purple-500 transition"
                        placeholder="Enter your Discord username"
                        required
                    >
                    @error('discord')
                        <p class="text-red-500 text-sm mt-1">{{ $message }}</p>
                    @enderror
                </div>

                <!-- Password Input -->
                <div class="mb-8">
                    <label for="password" class="block text-gray-700 font-semibold mb-2">
                        Password
                    </label>
                    <input
                        type="password"
                        id="password"
                        name="password"
                        class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-purple-500 transition"
                        placeholder="Enter your password"
                        required
                    >
                    @error('password')
                        <p class="text-red-500 text-sm mt-1">{{ $message }}</p>
                    @enderror
                </div>

                <!-- Submit Button -->
                <button
                    type="submit"
                    class="w-full bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-700 hover:to-indigo-700 text-white font-bold py-3 rounded-lg transition duration-200 transform hover:scale-105 active:scale-95"
                >
                    Login
                </button>
            </form>

            <!-- Footer -->
            <div class="mt-8 text-center text-gray-500 text-sm border-t pt-6">
                <p>Contact support for account access issues</p>
            </div>
        </div>
    </div>
</body>
</html>

