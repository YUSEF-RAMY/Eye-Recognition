<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class DataSetController extends Controller
{
    public function index()
    {
        return view('dataset.index');
    }

    public function store(Request $request)
    {
        $request->validate([
            'image' => 'required|image|max:4096',
        ]);

        $image = $request->file('image');
        $imageName = time() . '_' . $image->getClientOriginalName();
        $image->move(public_path('dataset'), $imageName);

        return response()->json(['message' => 'Image captured and stored successfully.'], 201);
    }
    
}
