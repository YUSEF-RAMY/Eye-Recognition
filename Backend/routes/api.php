<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\NewPersonController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\RecognitionController;
use App\Http\Controllers\DataSetController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
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

Route::post('/dataset/capture', [DataSetController::class, 'store']);

Route::get('/test', function () {
    return response()->json(['status' => 'ok']);
});

Route::get('/ping', function () {
    $url = "https://donation-witness-cave-households.trycloudflare.com/test";

    $response = Http::withHeaders([
        'Accept' => 'application/json',
        'User-Agent' => 'Mozilla/5.0',
        'Host' => env('AI_SERVICE_HOST'),
    ])->get($url);

    return $response->body();
});

// Route::post('/recognize', function(Request $request) {

//     // تحقق من وجود صورة
//     $request->validate([
//         'image' => 'required|image|max:4096',
//     ]);

//     $file = $request->file('image');
//     $fileContents = file_get_contents($file->getRealPath());

//     // الـ URL اللي مولده Cloudflare Tunnel
//     $aiServiceUrl = env('AI_SERVICE_URL'); // مثال: https://abc123.trycloudflare.com/predict

//     try {
//         $response = Http::withHeaders([
//             'Accept' => 'application/json',
//             'User-Agent' => 'Mozilla/5.0',
//         ])
//         ->asMultipart()
//         ->attach('file', $fileContents, $file->getClientOriginalName()) // تأكد من اسم field المطلوب
//         ->post($aiServiceUrl);

//         // لو السيرفر رجع JSON
//         if ($response->successful()) {
//             return response()->json([
//                 'status' => 'success',
//                 'data' => $response->json(),
//             ]);
//         }

//         // لو فيه أي خطأ من السيرفر (400، 500…)
//         return response()->json([
//             'status' => 'error',
//             'http_code' => $response->status(),
//             'body' => $response->body(), // هتشوف HTML أو JSON كامل من السيرفر
//         ], $response->status());

//     } catch (\Exception $e) {
//         // لو فيه مشكلة في الاتصال بالـ tunnel
//         return response()->json([
//             'status' => 'exception',
//             'message' => $e->getMessage(),
//         ], 500);
//     }
// });