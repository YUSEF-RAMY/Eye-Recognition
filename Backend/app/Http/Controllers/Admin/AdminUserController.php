<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class AdminUserController extends Controller
{
   public function show(Request $request, $id)
{
    $user = User::findOrFail($id);
    $perPage = 10; // عدد الصور في الصفحة الواحدة

    // جلب ملفات العين والوجه
    $eyePath = "eye-dataset/users/user_{$id}/eye";

$eyeFiles = Storage::disk('public')->exists($eyePath) 
                ? collect(Storage::disk('public')->files($eyePath))->reverse()->values()->all() 
                : [];
    // تحويلهم لباجينيشن يدوي
    $eyeImages = $this->customPaginate($eyeFiles, $perPage, $request->query('eye_page'), 'eye_page');

    return view('Admin.user-details', compact('user', 'eyeImages'));
}

private function customPaginate($items, $perPage, $page, $pageName)
{
    $page = $page ?: 1;
    $items = collect($items);
    return new LengthAwarePaginator(
        $items->forPage($page, $perPage),
        $items->count(),
        $perPage,
        $page,
        ['path' => request()->url(), 'query' => request()->query(), 'pageName' => $pageName]
    );
}


public function destroy($id)
{
    if (Auth::user()->role !== 'sudo') {
        return back()->with('error', 'Unauthorized action.');
    }

    $user = User::findOrFail($id);

    $user->delete();

    return back()->with('success', 'User and their data deleted successfully.');
}
}