<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\NewPersonController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\RecognitionController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;





Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::post('/login', [AuthController::class, 'login']);
Route::post('/register', [AuthController::class, 'register']);
Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');


Route::middleware('auth:sanctum')->group(function () {
Route::post('/recognize', [RecognitionController::class, 'recognize']);
Route::post('/add-person', [NewPersonController::class, 'store']);
Route::get('/people', [NewPersonController::class, 'index']);
});

Route::middleware(['auth:sanctum'])->group(function () {
    Route::get('/show-user-info', [ProfileController::class, 'show']);
    Route::post('/update-password', [ProfileController::class, 'updatePassword']);
    Route::post('/update-profile-image', [ProfileController::class, 'updateProfileImage']);
});
