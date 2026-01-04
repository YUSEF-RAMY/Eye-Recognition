<?php

namespace App\Http\Controllers;

use App\Models\DataSet;
use Dflydev\DotAccessData\Data;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class DataSetController extends Controller
{
    public function index()
    {
        return view('dataset.index');
    }

    public function store(Request $request)
    {
        $request->validate([
            'full_image' => 'required|string',
            'eye_image'  => 'required|string',
        ]);

        // حفظ الصور
        $fullPath = $this->saveBase64($request->full_image,'full_image');

        $eyeData = $this->saveBase64($request->eye_image,'eye_image',true);

        // تسجيل في DB
        DataSet::create([
            'full_image_path' => $fullPath,
            'eye_image_path'  => $eyeData['path'],
            'roi_width'       => $eyeData['width'],
            'roi_height'      => $eyeData['height'],
        ]);

        return response()->json([
            'status' => 'success'
        ]);
    }

    private function saveBase64($base64, $folder, $returnSize = false)
    {
        preg_match('/^data:image\/(\w+);base64,/', $base64, $type);
        $base64 = substr($base64, strpos($base64, ',') + 1);

        $image = base64_decode($base64);
        $ext = $type[1] ?? 'png';

        $fileName = $folder.'_'.uniqid().'.'.$ext;
        $path = "eye-dataset/{$folder}/".$fileName;

        Storage::disk('public')->put($path, $image);

        if ($returnSize) {
            [$w, $h] = getimagesizefromstring($image);

            return [
                'path'   => 'storage/'.$path,
                'width'  => $w,
                'height' => $h
            ];
        }

        return 'storage/'.$path;
    }
    
}
