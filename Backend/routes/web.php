<?php

use App\Http\Controllers\Admin\AdminUserController;
use App\Http\Controllers\Auth\RegisteredUserController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\DataSetController;
use App\Http\Controllers\ProfileController;
use App\Http\Middleware\Sudo;
use App\Models\DataSet;
use App\Models\User;
use Illuminate\Support\Facades\Route;




Route::get('/', function () {
    
    return view('auth.login');
});

Route::get('/dashboard', [DashboardController::class, 'index'])->middleware(['auth', 'verified'])->name('dashboard');


Route::middleware(['auth'])->group(function () {
    // عرض الصفحة
    Route::get('/dataset', [DataSetController::class, 'index'])->name('capture.index');
    
    // استقبال الصور وحفظها
    Route::post('/dataset/capture', [DataSetController::class, 'store'])->name('capture.store');
});

Route::get('register' , [RegisteredUserController::class, 'create'])->name('register');
Route::post('register' , [RegisteredUserController::class, 'store'])->name('register');


Route::get('/admin/user/{id}', [AdminUserController::class, 'show'])
    ->name('admin.user.show')
    ->middleware(['auth', Sudo::class]);

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});

require __DIR__.'/auth.php';
