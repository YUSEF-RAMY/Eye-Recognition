<x-app-layout>
    <x-slot name="header">
        <div class="flex flex-col md:flex-row justify-between items-center gap-4">
            <h2 class="font-bold text-2xl text-gray-800 dark:text-gray-200 leading-tight">
                لوحة التحكم الإدارية
            </h2>

            <div class="flex items-center gap-3">
                <a href="{{ route('capture.index') }}"
                    class="inline-flex items-center px-6 py-3 bg-gray-600 border border-transparent rounded-xl font-bold text-sm text-black uppercase tracking-widest hover:bg-gray-700 transition ease-in-out duration-150 shadow-md">
                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z">
                        </path>
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M15 13a3 3 0 11-6 0 3 3 0 016 0z"></path>
                    </svg>
                    Capture Data Set
                </a>
                @if (Auth::user()->role === 'sudo')
                    <a href="{{ route('register') }}"
                        class="inline-flex items-center px-6 py-3 bg-indigo-600 border border-transparent rounded-xl font-bold text-sm text-black uppercase tracking-widest hover:bg-indigo-700 transition ease-in-out duration-150 shadow-lg shadow-indigo-200 dark:shadow-none">
                        <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z">
                            </path>
                        </svg>
                        إضافة مستخدم
                    </a>
                @endif

            </div>
        </div>
    </x-slot>

    <div class="py-12 bg-gray-50 dark:bg-gray-900 min-h-screen">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">

            @if (Auth::user()->email === 'sudo@sudo.com')

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-6 mb-10">
                    <div
                        class="bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-100 dark:border-gray-700 p-6 flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-500 uppercase tracking-wider">إجمالي المستخدمين</p>
                            <p class="text-3xl font-black text-gray-900 dark:text-white mt-1">{{ $users->count() }}</p>
                        </div>
                        <div class="rounded-2xl bg-blue-50 dark:bg-blue-900/20 p-4 text-blue-600">
                            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z">
                                </path>
                            </svg>
                        </div>
                    </div>
                </div>

                <h3 class="text-xl font-bold text-gray-800 dark:text-white mb-6">قائمة المستخدمين</h3>

                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    @foreach ($users as $user)
                        <div
                            class="group bg-white dark:bg-gray-800 rounded-3xl shadow-sm border border-gray-100 dark:border-gray-700 hover:shadow-2xl hover:-translate-y-1 transition-all duration-300 overflow-hidden">
                            <div class="p-8">
                                <div class="flex items-center space-x-4 space-x-reverse mb-6">
                                    <div
                                        class="h-16 w-16 rounded-2xl bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center text-white text-2xl font-bold shadow-lg shadow-indigo-100 dark:shadow-none">
                                        {{ substr($user->name, 0, 1) }}
                                    </div>
                                    <div>
                                        <h4 class="text-xl font-extrabold text-gray-900 dark:text-white truncate">
                                            {{ $user->name }}</h4>
                                        <span
                                            class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300">
                                            ID: #{{ $user->id }}
                                        </span>
                                    </div>
                                </div>

                                <div class="space-y-4">
                                    <div
                                        class="bg-gray-50 dark:bg-gray-900/50 p-4 rounded-2xl border border-gray-100 dark:border-gray-800">
                                        <p class="text-xs text-gray-400 uppercase font-bold tracking-wider mb-1">البريد
                                            الإلكتروني</p>
                                        <p class="text-sm font-semibold text-gray-800 dark:text-gray-200 truncate">
                                            {{ $user->email }}</p>
                                    </div>

                                    <div
                                        class="flex items-center justify-between p-4 bg-indigo-50 dark:bg-indigo-900/20 rounded-2xl transition-colors group-hover:bg-indigo-100 dark:group-hover:bg-indigo-900/40">
                                        <div class="flex items-center text-indigo-700 dark:text-indigo-400">
                                            <svg class="w-5 h-5 ml-2" fill="none" stroke="currentColor"
                                                viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                    d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z">
                                                </path>
                                            </svg>
                                            <span class="text-sm font-bold">إجمالي الصور المجمعة</span>
                                        </div>
                                        <span class="text-lg font-black text-indigo-800 dark:text-indigo-300">
                                            {{ $user->storage_count ?? 0 }}
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    @endforeach
                </div>
            @else
                <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-3xl p-12 text-center">
                    <h2 class="text-2xl font-bold text-gray-900 dark:text-white mb-2 italic">
                        {{"Welcome : " . Auth::user()->name . " 😘"}}
                    </h2>
                </div>
            @endif

        </div>
    </div>
</x-app-layout>
