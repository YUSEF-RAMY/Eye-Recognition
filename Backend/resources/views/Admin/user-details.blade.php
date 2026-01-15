<x-app-layout>
    <div x-data="{ open: false, imgSrc: '' }" class="relative">
        
        <x-slot name="header">
            <div class="flex flex-col md:flex-row justify-between items-center gap-4 bg-white dark:bg-gray-800 p-4 rounded-3xl shadow-sm border border-gray-100 dark:border-gray-700">
                <div class="flex items-center gap-4">
                    <div class="h-12 w-12 rounded-2xl bg-indigo-50 dark:bg-indigo-900/30 flex items-center justify-center text-indigo-600">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                        </svg>
                    </div>
                    <div>
                        <h2 class="font-black text-2xl text-slate-800 dark:text-white leading-tight">
                            User Profile: <span class="text-indigo-600">{{ $user->name }}</span>
                        </h2>
                        <p class="text-xs font-bold text-slate-400 uppercase tracking-widest">User ID: #{{ $user->id }}</p>
                    </div>
                </div>

                <a href="{{ route('dashboard') }}" class="inline-flex items-center px-6 py-3 bg-slate-100 dark:bg-gray-700 text-slate-700 dark:text-gray-200 rounded-2xl font-bold text-xs uppercase tracking-widest hover:bg-slate-200 transition duration-200">
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path>
                    </svg>
                    Back to Dashboard
                </a>
            </div>
        </x-slot>

        <div class="py-12 bg-[#f8fafc] dark:bg-gray-900 min-h-screen">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
                
                <section class="mb-16">
                    <div class="flex items-center gap-3 mb-10">
                        <span class="w-2 h-8 bg-indigo-600 rounded-full"></span>
                        <h3 class="text-2xl font-black text-slate-800 dark:text-white uppercase tracking-wider">
                            Eye Dataset Collection 
                            <span class="ml-2 text-sm font-bold text-slate-400">({{ $eyeImages->total() }} items)</span>
                        </h3>
                    </div>
                    
                    <div class="columns-1 sm:columns-2 lg:columns-3 gap-6 space-y-6">
                        @foreach($eyeImages as $path)
                            <div class="break-inside-avoid bg-white dark:bg-gray-800 p-3 rounded-[2.5rem] shadow-md border border-gray-100 dark:border-gray-700 hover:shadow-2xl hover:border-indigo-300 transition-all duration-500 group cursor-pointer"
                                 @click="imgSrc = '{{ asset('storage/' . $path) }}'; open = true">
                                
                                <div class="relative overflow-hidden rounded-[2rem]">
                                    <img src="{{ asset('storage/' . $path) }}" 
                                         class="w-full h-auto object-contain transition-transform duration-700 group-hover:scale-105"
                                         alt="Eye Image">
                                    
                                    <div class="absolute bottom-4 right-4 opacity-0 group-hover:opacity-100 transition-opacity">
                                        <div class="bg-white/90 backdrop-blur p-2 rounded-full shadow-lg">
                                            <svg class="w-5 h-5 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0zM10 7v3m0 0v3m0-3h3m-3 0h-3"></path>
                                            </svg>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        @endforeach
                    </div>

                    <div class="mt-12">
                        {{ $eyeImages->appends(request()->except('eye_page'))->links() }}
                    </div>
                </section>

                <div x-show="open" 
                     x-transition:enter="transition ease-out duration-300"
                     x-transition:enter-start="opacity-0"
                     x-transition:enter-end="opacity-100"
                     x-transition:leave="transition ease-in duration-200"
                     x-transition:leave-start="opacity-100"
                     x-transition:leave-end="opacity-0"
                     class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/90 backdrop-blur-md"
                     @click.away="open = false"
                     style="display: none;">
                    
                    <button @click="open = false" class="absolute top-6 right-6 text-white hover:text-indigo-400 transition-colors">
                        <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                        </svg>
                    </button>

                    <img :src="imgSrc" class="max-w-full max-h-[90vh] rounded-3xl shadow-2xl border-4 border-white/10 shadow-indigo-500/20">
                </div>

            </div>
        </div>
    </div>
</x-app-layout>