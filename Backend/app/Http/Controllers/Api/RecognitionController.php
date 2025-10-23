<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Person;
use App\Models\Recognition;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class RecognitionController extends Controller
{
    public function recognize(Request $request)
    {
        $request->validate([
            'image' => 'required|image|max:4096',
        ]);

        $path = $request->file('image')->store('recognitions', 'public');
        $imageUrl = asset('storage/' . $path);

        try {
            $response = Http::attach(
                'image',
                file_get_contents($request->file('image')->getRealPath()),
                $request->file('image')->getClientOriginalName()
            )->post('ai/link/recognize');

            if ($response->successful()) {
                $data = $response->json();

                if (!empty($data['name'])) {
                    $person = Person::where('name', $data['name'])->first();

                    Recognition::create([
                        'person_id' => $person->id ?? null,
                        'status' => 'recognized',
                        'confidence' => round($data['confidence'] * 100, 2) . '%',
                    ]);

                    return response()->json([
                        'status' => 'recognized',
                        'name' => $data['name'],
                        'image' => $imageUrl,
                        'confidence' => round($data['confidence'] * 100, 2) . '%',
                    ]);
                } else {
                    Recognition::create([
                        'person_id' => null,
                        'status' => 'unknown',
                        'confidence' => null,
                    ]);

                    return response()->json([
                        'status' => 'unknown',
                        'message' => 'New person detected. Please register.',
                    ]);
                }
            }

            return response()->json([
                'error' => 'AI service error',
                'details' => $response->body(),
            ], 500);

        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Connection error with AI service',
                'message' => $e->getMessage(),
            ], 500);
        }
    }
}
