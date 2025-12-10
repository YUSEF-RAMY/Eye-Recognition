import 'dart:developer';
import 'dart:io';
import 'package:eye_recognition/data/api.dart';
import 'package:eye_recognition/main.dart';
import 'package:http/http.dart' as http;

class AddNewPersonRequest {
  Future<String> addNewPersonRequest({required String name,required File imageFile}) async {
    Map<String, dynamic> data = await Api().post(
      url: '${EyeRecognition.baseUrl}/api/add-person',
      body: {
        'name': name,
        'image': await http.MultipartFile.fromPath('image', imageFile.path),
      },
      token: EyeRecognition.token,
    );
    log("Add this person Success: ${data}");
    EyeRecognition.success = true;
    return data['result']; //edit this field from api response
  }
}
