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

        $file = $request->file('image');
        $fileContents = file_get_contents($file->getRealPath());

        $aiServiceUrl = env('AI_SERVICE_URL');

        try {
            $response = Http::withHeaders([
                'Accept' => 'application/json',
                'User-Agent' => 'Mozilla/5.0',
            ])
                ->asMultipart()
                ->attach('file', $fileContents, $file->getClientOriginalName())
                ->post($aiServiceUrl);
            
            if ($response->successful()) {
                $json = $response->json();

                $name = $json['name'] ?? "الاسم مش جاي";
                $score = $json['best_score'] ?? "الاسكور مش جاي";
                return response()->json([
                    'name' => $name,
                    'best_score' => $score,
                ]);
            }

            return response()->json(
                [
                    'status' => 'error',
                    'http_code' => $response->status(),
                    'body' => $response->body(),
                ],
                $response->status(),
            );
        } catch (\Exception $e) {
            return response()->json(
                [
                    'status' => 'exception with tunnel',
                    'message' => $e->getMessage(),
                ],
                500,
            );
        }
    }
    // $request->validate([
    //     'image' => 'required|image|max:4096',
    // ]);

    // $file = $request->file('image');
    // $path = $file->store('recognitions', 'public');
    // $imageUrl = asset('storage/' . $path);

    // try {
    //     $response = Http::withHeaders([
    //         'Accept' => 'application/json',
    //         'User-Agent' => 'Mozilla/5.0',
    //         'Host' => env('AI_SERVICE_HOST'),
    //     ])
    //         ->asMultipart()
    //         ->attach('file', file_get_contents($file->getRealPath()), $file->getClientOriginalName())
    //         ->post(env('AI_SERVICE_URL'));

    //     if ($response->successful()) {
    //         $data = $response->json();

    //         if (!empty($data['name'])) {
    //             $person = Person::where('name', $data['name'])->first();

    //             Recognition::create([
    //                 'person_id' => $person->id ?? null,
    //                 'status' => 'recognized',
    //                 'confidence' => round($data['confidence'] * 100, 2) . '%',
    //             ]);

    //             return response()->json([
    //                 'status' => 'recognized',
    //                 'name' => $data['name'],
    //                 'image' => $imageUrl,
    //                 'confidence' => round($data['confidence'] * 100, 2) . '%',
    //             ]);
    //         } else {
    //             Recognition::create([
    //                 'person_id' => null,
    //                 'status' => 'unknown',
    //                 'confidence' => null,
    //             ]);

    //             return response()->json([
    //                 'status' => 'unknown',
    //                 'message' => 'New person detected. Please register.',
    //             ]);
    //         }
    //     }

    //     return response()->json(
    //         [
    //             'error' => 'AI service error Line 64',
    //             'details' => $response->body(),
    //         ],
    //         500,
    //     );
    // } catch (\Exception $e) {
    //     return response()->json(
    //         [
    //             'error' => 'Connection error with AI service Line 71',
    //             'message' => $e->getMessage(),
    //         ],
    //         500,
    //     );
    // }
}
