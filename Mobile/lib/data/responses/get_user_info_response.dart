import 'dart:developer';
import 'package:eye_recognition/data/api.dart';
import 'package:eye_recognition/data/models/user_model.dart';
import 'package:eye_recognition/main.dart';

class GetUserInfoResponse {
  Future<UserModel> getUserInfoResponse() async {
    Map<String,dynamic> data = await Api().get(
      url: '${EyeRecognition.baseUrl}/api/show-user-info',
      token: EyeRecognition.token,
    );
    UserModel user = UserModel.fromjson(data);
    log("Success: ${user}");
    EyeRecognition.success = true;
    return user; //edit this field from api response
  }
}
