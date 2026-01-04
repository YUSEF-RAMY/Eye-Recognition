<?php

use App\Http\Controllers\ProfileController;
use App\Http\Controllers\DataSetController;
use App\Models\DataSet;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    
    return view('auth.login');
});

Route::get('/dashboard', function () {
    $images = DataSet::orderBy('created_at' , 'desc')->paginate(15);
    return view('dashboard' , compact('images'));
})->middleware(['auth', 'verified'])->name('dashboard');


Route::get('dataset', [DataSetController::class , 'index']);

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});

require __DIR__.'/auth.php';
