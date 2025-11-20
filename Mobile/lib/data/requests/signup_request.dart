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
    Map<String, dynamic> data = await Api().post(
      url: '${EyeRecognition.baseUrl}', //complete this url
      body: {
        'userName': userName,
        'email': email,
        'image': imageFile == null
            ? null
            : await http.MultipartFile.fromPath('image', imageFile.path),
        'password': password,
        'confirmPassword': confirmPassword,
      },
    );
    String oldToken = data['token'];
    String token = oldToken.split('|').last;
    return token;
  }
}
