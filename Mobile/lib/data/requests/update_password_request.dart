import 'dart:developer';
import 'dart:io';
import 'package:eye_recognition/data/api.dart';
import 'package:eye_recognition/main.dart';

class UpdatePasswordRequest {
  Future<String> updatePasswordRequest({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    Map<String, dynamic> data = await Api().post(
      url: '${EyeRecognition.baseUrl}/api/logout',
      body: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': confirmNewPassword,
      },
      token: EyeRecognition.token,
    );
    log("Success: ${data}");
    EyeRecognition.success = true;
    return data['result']; //edit this field from api response
  }
}
