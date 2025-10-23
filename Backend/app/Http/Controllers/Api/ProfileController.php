<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\UserResource;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class ProfileController extends Controller
{
    public function show(Request $request)
    {
        $user = $request->user();

        return response()->json([
            'user' => new UserResource($user),
        ]);
    }

    public function updatePassword(Request $request)
    {
        $request->validate([
            'current_password' => 'required',
            'new_password' => 'required|min:8|confirmed', //confirmed input name => new_password_confirmation
        ]);

        $user = $request->user();

        if (!Hash::check($request->current_password, $user->password)) {
            return response()->json([
                'message' => 'The old password is incorrect.',
            ], 422);
        }

        $user->update([
            'password' => Hash::make($request->new_password),
        ]);

        return response()->json([
            'message' => 'Your password has been changed successfully.',
        ]);
    }
    
    public function updateProfileImage(Request $request)
{
    $request->validate([
        'image' => 'required|image|max:4096',
    ]);

    $user = $request->user();
    $path = $request->file('image')->store('users', 'public');
    $url = asset('storage/' . $path);
    $user->update(['image_path' => $url]);

    return response()->json([
        'message' => 'Image updated successfully.',
        'image' => $url,
    ]);
}
}