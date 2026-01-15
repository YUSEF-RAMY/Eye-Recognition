<?php

namespace App\Http\Controllers;

use App\Models\DataSet;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class DashboardController extends Controller
{
    public function index()
    {
        $userId = Auth::id();

        $users = User::withCount('images')->get();
        $images = DataSet::all();

        foreach ($users as $user) {
        $userFolder = "eye-dataset/users/user_{$user->id}/eye";
        if (Storage::disk('public')->exists($userFolder)) {
            $files = Storage::disk('public')->files($userFolder);
            $user->storage_count = count($files);
        } else {
            $user->storage_count = 0;
        }
    }

        return view('dashboard', compact('images', 'users'));
    }
}
