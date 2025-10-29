import 'dart:developer';
import 'dart:io';
import 'package:eye_recognition/data/api.dart';
import 'package:eye_recognition/main.dart';
import 'package:http/http.dart' as http;

class LogoutRequest {
  Future<String> logoutRequest({required File imageFile}) async {
    Map<String, dynamic> data = await Api().post(
      url: '${EyeRecognition.baseUrl}/api/logout',
      body: {},
      token: EyeRecognition.token,
    );
    log("Success: ${data}");
    EyeRecognition.success = true;
    return data['result']; //edit this field from api response
  }
}
