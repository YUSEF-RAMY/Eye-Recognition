import 'dart:developer';
import 'dart:io';
import 'package:eye_recognition/data/api.dart';
import 'package:eye_recognition/main.dart';
import 'package:http/http.dart' as http;

class RecognizeRequest {
  Future<String> recognizeRequest({required File imageFile}) async {
    Map<String, dynamic> data = await Api().post(
      url: '${EyeRecognition.baseUrl}/api/recognize',
      body: {
        'image': await http.MultipartFile.fromPath('image', imageFile.path),
      },
      token: EyeRecognition.token,
    );
    log("Upload image Success: ${data}");
    EyeRecognition.success = true;
    return data['name']??data['status'];
  }
}
