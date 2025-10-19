<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Person;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class NewPersonController extends Controller
{
    public function index()
    {
        return response()->json(Person::all());
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:100',
            'image' => 'required|image|max:4096',
        ]);

        $path = $request->file('image')->store('people', 'public');

        Http::attach(
            'image',
            file_get_contents($request->file('image')->getRealPath()),
            $request->file('image')->getClientOriginalName()
        )->post('/add_person_ai', [
            'name' => $request->name,
        ]);

        $person = Person::create([
            'name' => $request->name,
            'image_path' => $path,
        ]);

        return response()->json([
            'message' => 'Person added successfully',
            'person' => $person,
        ], 201);
    }
}
