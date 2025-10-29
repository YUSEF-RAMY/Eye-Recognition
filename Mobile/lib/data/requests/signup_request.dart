import '../../main.dart';
import '../api.dart';

class SignupRequest {
  Future<String> signupRequest({
    required String userName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    Map<String, dynamic> data = await Api().post(
      url: '${EyeRecognition.baseUrl}', //complete this url
      body: {
        'userName': userName,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
      },
    );
    String oldToken = data['token'];
    String token = oldToken.split('|').last;
    return token;
  }
}
