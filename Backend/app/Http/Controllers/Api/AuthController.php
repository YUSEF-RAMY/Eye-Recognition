<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required|string|min:6',
        ]);

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json(['error' => 'Invalid Login Credentials'], 401);
        }

        $token = $user->createToken('mobile')->plainTextToken;

        return (new UserResource($user))->additional(
            [
                'token' => $token,
                'message' => 'You Have Been Logged In Successfully',
            ],
        );
    }

    public function register(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:6|confirmed',
            'image' => 'nullable|image|max:4096',
        ]);

        $url = null; 
        if($request->hasFile('image')){
            $path = $request->file('image')->store('users', 'public');
            // $url = asset('storage/'. $path);
        }else{
            $url = asset('storage/people/user-1.jpeg');
        }

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'image_path' => $path,
        ]);

        $token = $user->createToken('mobile')->plainTextToken;

        return (new UserResource($user))->additional(
            [
                'token' => $token,
                'message' => 'You Have Been Registered Successfully',
            ],
        );
    }

    public function logout(Request $request)
    {
        $user = $request->user();

        if ($user) {
            $user->tokens()->delete();
        }
        return response()->json(['message' => 'You Have Been Logged Out Successfully'], 200);
    }
}
