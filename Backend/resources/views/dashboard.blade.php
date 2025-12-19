<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
            {{ __('Dashboard') }}
        </h2>
    </x-slot>

    @if (Auth::user()->email === 'sudo@sudo.com')
    <div class="container mx-auto p-4">
        <h1 class="text-2xl font-bold mb-6 text-center text-white">Data Set</h1>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                @foreach ($images as $image)
                   <div class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-xl transition-shadow duration-300">
        
        <!-- الصورة -->
        <div class="w-full aspect-[4/3] bg-gray-700 flex items-center justify-center">
            <img src="{{ asset('storage/'. $image->image_path) }}" alt="صورة" class="w-full h-full object-contain">
        </div>

        <!-- التفاصيل -->
        <div class="p-4">
            <h2 class="text-lg font-semibold text-gray-800">Taked By : {{ $image->user_name }}</h2>
        </div>
    </div>
                @endforeach
            </div>
    </div>
        @else
    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-6 text-gray-900 dark:text-gray-100">
                    Hello {{ Auth::user()->name }} You Are Logged in 😉❤
                </div>
            </div>
        </div>
    </div>
    @endif


</x-app-layout>
