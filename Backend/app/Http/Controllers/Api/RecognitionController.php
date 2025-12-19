<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\DataSet;
use App\Models\Person;
use App\Models\Recognition;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Http;

class RecognitionController extends Controller
{
    public function recognize(Request $request)
    {
        $request->validate([
            'image' => 'required|image|max:4096',
        ]);

        $file = $request->file('image');
        $path = $file->store('DataSet', 'public');
        $fileContents = file_get_contents($file->getRealPath());

        DataSet::create([
            'image_path' => $path,
            'user_id' => Auth::user()->id,
            'user_name' => Auth::user()->name,
        ]);
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

                Recognition::create([
                    'person_id' => Auth::user()->id,
                    'status' => 'recognized',
                    'image_path' => $path,
                    'confidence' => $score,
                ]);
                return response()->json([
                    'name' => $name,
                    'best_score' => $score,
                ]);
            }

            return response()->json(
                [
                    'status' => 'No Replay form AI',
                    'http_code' => $response->status(),
                    'body' => $response->body(),
                ],
                $response->status(),
            );
        } catch (\Exception $e) {
            return response()->json(
                [
                    'status' => 'The AI Server Ss Locked.',
                    'message' => $e->getMessage(),
                ],
                500,
            );
        }
    }
}
