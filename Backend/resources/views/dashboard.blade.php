<x-app-layout>
    <x-slot name="header">
        <div
            class="flex flex-col md:flex-row justify-between items-center gap-4 bg-white dark:bg-gray-800 p-4 rounded-3xl shadow-sm border border-gray-100 dark:border-gray-700">
            <h2 class="font-black text-2xl text-slate-800 dark:text-white leading-tight">
                Admin Dashboard
            </h2>
            @if (session('error'))
                <div class="alert alert-danger">{{ session('error') }}</div>
            @endif
            <div class="flex items-center gap-3">
                <a href="{{ route('capture.index') }}"
                    class="inline-flex items-center px-6 py-3 bg-slate-100 dark:bg-gray-700 text-slate-700 dark:text-gray-200 rounded-2xl font-bold text-xs uppercase tracking-widest hover:bg-slate-200 transition duration-200">
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
                        class="inline-flex items-center px-6 py-3 bg-indigo-600 text-white rounded-2xl font-bold text-xs uppercase tracking-widest hover:bg-indigo-700 shadow-lg shadow-indigo-200 dark:shadow-none transition duration-200">
                        <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z">
                            </path>
                        </svg>
                        Add User
                    </a>
                @endif
            </div>
        </div>
    </x-slot>

    <div class="py-12 bg-[#f8fafc] dark:bg-gray-900 min-h-screen">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">

            @if (Auth::user()->role === 'sudo' || Auth::user()->role === 'ai_team')
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-10">
                    <div
                        class="bg-white dark:bg-gray-800 rounded-3xl p-6 border border-gray-100 dark:border-gray-700 shadow-sm">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-bold text-slate-400 uppercase tracking-wider">Total Users</p>
                                <p class="text-3xl font-black text-slate-800 dark:text-white mt-1">{{ $users->count() }}
                                </p>
                            </div>
                            <div class="bg-indigo-50 dark:bg-indigo-900/30 p-4 rounded-2xl">
                                <svg class="w-8 h-8 text-indigo-600" fill="none" stroke="currentColor"
                                    viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z">
                                    </path>
                                </svg>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mb-8 text-left">
                    <h3 class="text-xl font-black text-slate-800 dark:text-white">User Account Management</h3>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    @foreach ($users as $user)
                        <div
                            class="group bg-white dark:bg-gray-800 rounded-[2.5rem] border border-gray-100 dark:border-gray-700 shadow-sm hover:shadow-2xl hover:border-indigo-200 transition-all duration-300 overflow-hidden text-left">
                            <div class="p-8">
                                <div class="flex items-center gap-4 mb-8">
                                    <div
                                        class="h-16 w-16 rounded-[1.25rem] bg-indigo-600 flex items-center justify-center text-white text-2xl font-black shadow-lg shadow-indigo-200">
                                        {{ strtoupper(substr($user->name, 0, 1)) }}
                                    </div>
                                    <div class="flex-1 min-w-0">
                                        <h4 class="text-xl font-black text-slate-800 dark:text-white truncate">
                                            {{ $user->name }}</h4>
                                        <div class="flex items-center gap-2 mt-1">
                                            <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
                                            <span
                                                class="text-xs font-bold text-slate-400 uppercase tracking-tighter">ID:
                                                #{{ $user->id }}</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="space-y-4">
                                    <div
                                        class="bg-slate-50 dark:bg-gray-900/50 p-4 rounded-2xl border border-slate-100 dark:border-gray-800">
                                        <p
                                            class="text-[10px] text-slate-400 uppercase font-black mb-1 tracking-widest text-left">
                                            Email Address</p>
                                        <p class="text-sm font-bold text-slate-700 dark:text-gray-200 truncate">
                                            {{ $user->email }}</p>
                                    </div>

                                    <div
                                        class="flex items-center justify-between p-4 bg-indigo-50/50 dark:bg-indigo-900/20 rounded-2xl border border-indigo-100/50 dark:border-indigo-800/50">
                                        <div class="flex items-center gap-3">
                                            <div
                                                class="p-2 bg-white dark:bg-gray-800 rounded-lg shadow-sm text-indigo-600">
                                                <svg class="w-5 h-5" fill="none" stroke="currentColor"
                                                    viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                        stroke-width="2"
                                                        d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z">
                                                    </path>
                                                </svg>
                                            </div>
                                            <span class="text-xs font-bold text-slate-500 dark:text-gray-400">Captured
                                                Images</span>
                                        </div>
                                        <span
                                            class="text-xl font-black text-indigo-700 dark:text-indigo-300">{{ $user->storage_count ?? 0 }}</span>
                                    </div>

                                    <div class="pt-2 flex flex-col gap-2">
                                        <a href="{{ route('admin.user.show', $user->id) }}"
                                            class="flex items-center justify-center w-full px-6 py-4 bg-slate-900 dark:bg-indigo-600 text-white rounded-2xl font-black text-xs uppercase tracking-[0.2em] hover:bg-slate-800 dark:hover:bg-indigo-700 transition duration-300 group-hover:scale-[1.02]">
                                            View User Details
                                        </a>

                                        @if (Auth::user()->role === 'sudo')
                                            <form action="{{ route('admin.user.destroy', $user->id) }}" method="POST"
                                                onsubmit="return confirm('Are you sure you want to delete this user?');">
                                                @csrf
                                                @method('DELETE')
                                                <button type="submit"
                                                    class="flex items-center justify-center w-full px-6 py-3 border-2 border-red-100 dark:border-red-900/30 text-red-600 dark:text-red-400 rounded-2xl font-bold text-xs uppercase tracking-widest hover:bg-red-50 dark:hover:bg-red-900/20 transition duration-200">
                                                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor"
                                                        viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round"
                                                            stroke-width="2"
                                                            d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16">
                                                        </path>
                                                    </svg>
                                                    Delete User
                                                </button>
                                            </form>
                                        @endif
                                    </div>
                                </div>
                            </div>
                        </div>
                    @endforeach
                </div>
            @else
                <div
                    class="bg-white dark:bg-gray-800 overflow-hidden shadow-2xl rounded-[3rem] p-20 text-center border border-gray-100 dark:border-gray-700">
                    <div class="inline-flex p-6 bg-indigo-50 dark:bg-indigo-900/30 rounded-full mb-6">
                        <span class="text-5xl">👋</span>
                    </div>
                    <h2 class="text-3xl font-black text-slate-800 dark:text-white mb-4 italic">
                        {{ 'Welcome back, ' . Auth::user()->name }}
                    </h2>
                    <p class="text-slate-500 dark:text-gray-400 font-bold uppercase tracking-widest text-sm">You have
                        successfully logged into the system</p>
                </div>
            @endif

        </div>
    </div>
</x-app-layout>
