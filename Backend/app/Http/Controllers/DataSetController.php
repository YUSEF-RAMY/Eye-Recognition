<?php

namespace App\Http\Controllers;

use App\Models\DataSet;
use Dflydev\DotAccessData\Data;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;

class DataSetController extends Controller
{
    public function index()
    {
        $userId = Auth::id();
    $userFolder = "eye-dataset/users/user_{$userId}/eye"; // سنعد ملفات الوجوه كمثال
    
    // جلب عدد الملفات الموجودة فعلياً في المجلد
    $files = Storage::disk('public')->files($userFolder);
    $initialCount = count($files);

    return view('dataset.index', compact('initialCount'));
    }

    public function store(Request $request)
{
    $userId = Auth::id(); 
    
    $faceData = $request->input('face_image');
    $eyeData = $request->input('eye_image');

    if (!$faceData || !$eyeData) {
        return response()->json(['error' => 'Images missing'], 400);
    }

    // استخدام الدالة المحسنة لحفظ الصور في مسار واضح
    $facePath = $this->saveBase64($faceData, $userId, 'face');
    $eyePath = $this->saveBase64($eyeData, $userId, 'eye');

    return response()->json([
        'message' => 'تم حفظ الصور بنجاح في مجلد المستخدم رقم ' . $userId,
        'face_path' => $facePath,
        'eye_path' => $eyePath
    ]);
}

   private function saveBase64($base64, $userId, $type)
{
    // 1. استخراج الصيغة
    preg_match('/^data:image\/(\w+);base64,/', $base64, $matches);
    $ext = $matches[1] ?? 'png';
    
    // 2. تنظيف كود الصورة
    $image = substr($base64, strpos($base64, ',') + 1);
    $image = base64_decode($image);

    // 3. تحديد المسار وتأكيده
    $userDirectory = "eye-dataset/users/user_{$userId}/{$type}";
    
    // التأكد من وجود المجلد، وإذا لم يوجد يتم إنشاؤه بصلاحيات كاملة
    if (!Storage::disk('public')->exists($userDirectory)) {
        Storage::disk('public')->makeDirectory($userDirectory, 0755, true);
    }

    $fileName = $type . '_' . time() . '_' . uniqid() . '.' . $ext;
    $path = "{$userDirectory}/{$fileName}";

    // 4. الحفظ
    Storage::disk('public')->put($path, $image);

    return 'storage/' . $path;
}
}
