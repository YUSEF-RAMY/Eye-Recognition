import 'dart:developer';
import 'dart:io';
import 'package:eye_recognition/data/api.dart';
import 'package:eye_recognition/main.dart';

class GetUserInfoResponse {
  Future<String> getUserInfoResponse() async {
    Map<String, dynamic> data = await Api().get(
      url: '${EyeRecognition.baseUrl}/api/show-user-info',
      token: EyeRecognition.token,
    );
    log("Success: ${data}");
    EyeRecognition.success = true;
    return data['result']; //edit this field from api response
  }
}
