import 'dart:developer';

import '../../main.dart';
import '../api.dart';

class LoginRequest {
  Future<String> loginRequest({
    required String email,
    required String password,
  }) async {
    Map<String, dynamic> data = await Api().post(
      url: '${EyeRecognition.baseUrl}/api/login', //complete this url
      body: {'email': email, 'password': password},
    );
    print(data);
    String oldToken = data['token'];
    String token = oldToken.split('|').last;
    return token;
  }
}
