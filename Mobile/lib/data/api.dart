import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:eye_recognition/main.dart';
import 'package:http/http.dart' as http;

class Api {
  Future<dynamic> get({required String url, String? token}) async {
    Map<String, String> headers = {};
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }
    print('url = $url \n token = $token');
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      log(response.body);
      EyeRecognition.success = true;
      return jsonDecode(response.body);
    } on HttpException catch (e) {
      EyeRecognition.success = false;
      throw Exception('this error from http exception $e');
    } catch (e) {
      EyeRecognition.success = false;
      throw Exception(e);
    }
  }

  Future<dynamic> post({
    required String url,
    required dynamic body,
    String? token,
  }) async {
    Map<String, String> headers = {'Accept': 'application/json'};
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    print('url = $url \n body = $body \n token = $token');

    try {
      //لو ال body يحتوي على MultipartFile -> نستخدم MultipartRequest
      if (body.values.any((v) => v is http.MultipartFile)) {
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.headers.addAll(headers);

        // إضافة الحقول (لو في نصوص)
        body.forEach((key, value) {
          if (value is http.MultipartFile) {
            request.files.add(value);
          } else {
            request.fields[key] = value.toString();
          }
        });

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        log(response.body);
        EyeRecognition.success = true;
        return jsonDecode(response.body);
      } else {
        http.Response response = await http.post(
          Uri.parse(url),
          body: body,
          headers: headers,
        );
        log("status = ${response.statusCode}");
        log(response.body);
        if (response.statusCode >= 200 && response.statusCode < 300) {
          EyeRecognition.success = true;
          final data = jsonDecode(response.body);
          return data;
        }
      }
    } on HttpException catch (e) {
      EyeRecognition.success = false;
      throw Exception('this error from http exception $e');
    } catch (e) {
      log(e.toString());
      EyeRecognition.success = false;
      throw Exception(e);
    }
  }

  /*Future<dynamic> oldPost({
    required String url,
    required dynamic body,
    String? token,
  }) async {
    Map<String, String> headers = {'Accept': 'application/json'};
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }
    print('url = $url \n body = $body \n token = $token');
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: body,
        headers: headers,
      );
      log(response.body);
      EyeRecognition.success = true;
      return jsonDecode(response.body);
    } on HttpException catch (e) {
      EyeRecognition.success = false;
      throw Exception('this error from http exception $e');
    } catch (e) {
      EyeRecognition.success = false;
      throw Exception(e);
    }
  }
*/

  Future<dynamic> put({
    required String url,
    required dynamic body,
    String? token,
  }) async {
    Map<String, String> headers = {'Accept': 'application/json'};
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }
    print('url = $url \n body = $body \n token = $token');
    try {
      http.Response response = await http.put(
        Uri.parse(url),
        body: body,
        headers: headers,
      );
      log(response.body);
      EyeRecognition.success = true;
      return jsonDecode(response.body);
    } on HttpException catch (e) {
      EyeRecognition.success = false;
      throw Exception('this error from http exception $e');
    } catch (e) {
      EyeRecognition.success = false;
      throw Exception(e);
    }
  }
}
