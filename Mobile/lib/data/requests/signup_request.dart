import 'dart:io';
import 'package:http/http.dart' as http;
import '../../main.dart';
import '../api.dart';

class SignupRequest {
  Future<String> signupRequest({
    required String userName,
    required String email,
    required File? imageFile,
    required String password,
    required String confirmPassword,
  }) async {
    Map<String, dynamic> body = {
      'name': userName,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
    };

// أضف الصورة فقط لو موجودة
    if (imageFile != null) {
      body['image'] =
      await http.MultipartFile.fromPath('image', imageFile.path);
    }
    Map<String, dynamic> data = await Api().post(
      url: '${EyeRecognition.baseUrl}/api/register', //complete this url
      body: body,
    );
    String oldToken = data['token'];
    String token = oldToken.split('|').last;
    return token;
  }
}
