<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Redeem Rewards - LoY CASADOS</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gradient-to-br from-purple-900 via-purple-800 to-indigo-900 min-h-screen">
    <!-- Navigation Bar -->
    <nav class="bg-black/30 backdrop-blur-md border-b border-purple-500/30">
        <div class="max-w-6xl mx-auto px-6 py-4 flex justify-between items-center">
            <div class="text-white">
                <h1 class="text-3xl font-bold">LoY <span class="text-purple-400">CASADOS</span></h1>
                <p class="text-purple-300 text-sm">Redeem Rewards</p>
            </div>
            <div class="flex gap-4">
                <a
                    href="{{ route('player.profile') }}"
                    class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded-lg transition"
                >
                    ← Back to Profile
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
    <div class="max-w-6xl mx-auto px-6">

        <!-- Drop Preferences Section -->
        <div class="bg-white rounded-lg shadow-lg p-8 mt-8">
            <h3 class="text-2xl font-bold text-purple-900 mb-2">⭐ My Drop Preferences</h3>
            <p class="text-gray-600 mb-6">Select up to 10 drops in order of preference (1 = highest priority)</p>

            @if (session('success'))
                <div class="mb-6 p-4 bg-green-50 border border-green-200 rounded-lg">
                    <p class="text-green-700 font-semibold">✅ {{ session('success') }}</p>
                </div>
            @endif

            <form method="POST" action="{{ route('player.redeem-rewards.update') }}">
                @csrf

                <div class="space-y-3 mb-8" id="preferencesContainer">
                    @if ($preferences && count($preferences) > 0)
                        @foreach ($preferences as $preference)
                            <div class="preference-item flex items-center gap-4 bg-purple-50 p-4 rounded-lg border-2 border-purple-200 cursor-move" draggable="true" data-drop-id="{{ $preference->drop_id }}">
                                <div class="flex-shrink-0 w-8 h-8 bg-purple-600 text-white rounded-full flex items-center justify-center font-bold text-sm">
                                    {{ $loop->iteration }}
                                </div>
                                <div class="flex-grow">
                                    <p class="font-semibold text-purple-900">{{ $preference->drop->name }}</p>
                                    <p class="text-sm text-gray-600">📍 {{ $preference->drop->place }}</p>
                                </div>
                                <button type="button" class="remove-btn text-red-600 hover:text-red-800 font-bold">✕</button>
                                <input type="hidden" name="preferences[]" value="{{ $preference->drop_id }}">
                            </div>
                        @endforeach
                    @endif
                </div>

                <!-- Available Drops to Add -->
                @php
                    $selectedDropIds = $preferences->pluck('drop_id')->toArray();
                    $availableDrops = $drops->filter(fn($drop) => !in_array($drop->id, $selectedDropIds));
                @endphp

                @if (count($preferences) < 10 && count($availableDrops) > 0)
                    <div class="mb-8">
                        <label class="block text-gray-700 font-semibold mb-3">Add More Drops</label>
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
                            @foreach ($availableDrops as $drop)
                                <button
                                    type="button"
                                    class="add-drop-btn text-left p-4 border-2 border-dashed border-purple-300 rounded-lg hover:border-purple-600 hover:bg-purple-50 transition"
                                    data-drop-id="{{ $drop->id }}"
                                    data-drop-name="{{ $drop->name }}"
                                    data-drop-place="{{ $drop->place }}"
                                >
                                    <p class="font-semibold text-purple-900">🎁 {{ $drop->quantity }}x {{ $drop->name }}</p>
                                    <p class="text-sm text-gray-600">📍 {{ $drop->place }}</p>
                                </button>
                            @endforeach
                        </div>
                    </div>
                @endif

                <div class="flex gap-4">
                    <button
                        type="submit"
                        class="bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-700 hover:to-indigo-700 text-white font-bold py-3 px-8 rounded-lg transition"
                    >
                        Save Preferences
                    </button>
                </div>
            </form>

            <div class="mt-8 p-4 bg-blue-50 rounded-lg border border-blue-200">
                <p class="text-sm text-blue-800">
                    <strong>ℹ️ Tip:</strong> Drag and drop your selected drops to reorder them by preference. Drop 1 has the highest priority.
                </p>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-black/30 backdrop-blur-md border-t border-purple-500/30 mt-12">
        <div class="max-w-6xl mx-auto px-6 py-6 text-center text-purple-300 text-sm">
            <p>&copy; 2026 LoY CASADOS. All rights reserved.</p>
        </div>
    </footer>

    <script>
        const container = document.getElementById('preferencesContainer');
        let draggedItem = null;

        // Inicializar event listeners
        function initializeEventListeners() {
            const addDropButtons = document.querySelectorAll('.add-drop-btn');
            const removeButtons = document.querySelectorAll('.remove-btn');

            // Add drop buttons
            addDropButtons.forEach(btn => {
                btn.removeEventListener('click', handleAddDrop);
                btn.addEventListener('click', handleAddDrop);
            });

            // Remove buttons
            removeButtons.forEach(btn => {
                btn.removeEventListener('click', handleRemoveDropClick);
                btn.addEventListener('click', handleRemoveDropClick);
            });

            // Setup drag listeners
            setupDragListeners();
        }

        function handleAddDrop(e) {
            e.preventDefault();
            const btn = e.target.closest('.add-drop-btn');
            const dropId = btn.dataset.dropId;
            const dropName = btn.dataset.dropName;
            const dropPlace = btn.dataset.dropPlace;
            const maxItems = 10;
            const currentItems = container.querySelectorAll('.preference-item').length;

            if (currentItems >= maxItems) {
                alert('Maximum 10 drops allowed!');
                return;
            }

            const newItem = document.createElement('div');
            newItem.classList.add('preference-item', 'flex', 'items-center', 'gap-4', 'bg-purple-50', 'p-4', 'rounded-lg', 'border-2', 'border-purple-200', 'cursor-move');
            newItem.draggable = true;
            newItem.dataset.dropId = dropId;
            newItem.innerHTML = `
                <div class="flex-shrink-0 w-8 h-8 bg-purple-600 text-white rounded-full flex items-center justify-center font-bold text-sm">
                    ${currentItems + 1}
                </div>
                <div class="flex-grow">
                    <p class="font-semibold text-purple-900">${dropName}</p>
                    <p class="text-sm text-gray-600">📍 ${dropPlace}</p>
                </div>
                <button type="button" class="remove-btn text-red-600 hover:text-red-800 font-bold">✕</button>
                <input type="hidden" name="preferences[]" value="${dropId}">
            `;

            container.appendChild(newItem);
            btn.style.display = 'none';

            // Setup listener para novo botão de remove
            newItem.querySelector('.remove-btn').addEventListener('click', handleRemoveDropClick);

            // Setup drag listeners
            setupDragListeners();
            updatePriorities();
        }

        function handleRemoveDropClick(e) {
            e.preventDefault();
            const item = e.target.closest('.preference-item');
            const dropId = item.dataset.dropId;
            item.remove();

            // Show the add button again
            const addBtn = document.querySelector(`.add-drop-btn[data-drop-id="${dropId}"]`);
            if (addBtn) addBtn.style.display = 'block';

            updatePriorities();
        }

        // Drag and Drop
        container.addEventListener('dragstart', (e) => {
            if (e.target.classList.contains('preference-item')) {
                draggedItem = e.target;
                e.target.style.opacity = '0.5';
            }
        });

        container.addEventListener('dragend', (e) => {
            if (e.target.classList.contains('preference-item')) {
                e.target.style.opacity = '1';
            }
        });

        container.addEventListener('dragover', (e) => {
            e.preventDefault();
            const afterElement = getDragAfterElement(container, e.clientY);
            if (afterElement == null) {
                container.appendChild(draggedItem);
            } else {
                container.insertBefore(draggedItem, afterElement);
            }
            updatePriorities();
        });

        function getDragAfterElement(container, y) {
            const draggableElements = [...container.querySelectorAll('.preference-item:not(.dragging)')];
            return draggableElements.reduce((closest, child) => {
                const box = child.getBoundingClientRect();
                const offset = y - box.top - box.height / 2;
                if (offset < 0 && offset > closest.offset) {
                    return { offset: offset, element: child };
                } else {
                    return closest;
                }
            }, { offset: Number.NEGATIVE_INFINITY }).element;
        }

        // Update priority numbers
        function updatePriorities() {
            const items = container.querySelectorAll('.preference-item');
            items.forEach((item, index) => {
                const badge = item.querySelector('div:first-child');
                badge.textContent = index + 1;
            });
        }

        function setupDragListeners() {
            const items = document.querySelectorAll('.preference-item');
            items.forEach(item => {
                item.draggable = true;
            });
        }

        // Inicializar quando a página carrega
        initializeEventListeners();
    </script>
</body>
</html>

