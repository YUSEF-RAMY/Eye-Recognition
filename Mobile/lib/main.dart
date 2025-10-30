import 'package:eye_recognition/presentation/screens/home_screen/home_screen.dart';
import 'package:eye_recognition/presentation/screens/profile_screen/profile_screen.dart';
import 'package:eye_recognition/presentation/screens/results_screen/results_screen.dart';
import 'package:eye_recognition/presentation/screens/signup_screen/signup_screen.dart';
import 'package:eye_recognition/presentation/screens/splash_screen/splash_screen.dart';
import 'package:eye_recognition/presentation/screens/upload_profile_photo_screen/upload_profile_photo_screen.dart';
import 'package:eye_recognition/presentation/screens/welcome_screen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'presentation/screens/login_screen/login_screen.dart';

void main() {
  runApp(const EyeRecognition());
}

class EyeRecognition extends StatelessWidget {
  const EyeRecognition({super.key});
  static String baseUrl = 'https://katydid-champion-mutually.ngrok-free.app';
  static late bool success;
  static late String token;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        SplashScreen.id : (context) => SplashScreen(),
        WelcomeScreen.id : (context) => WelcomeScreen(),
        LoginScreen.id : (context) => LoginScreen(),
        UploadProfilePhotoScreen.id : (context) => UploadProfilePhotoScreen(),
        SignupScreen.id : (context) => SignupScreen(),
        HomeScreen.id : (context) => HomeScreen(),
        ProfileScreen.id : (context) => ProfileScreen(),
        ResultsScreen.id : (context) => ResultsScreen(),
      },
      initialRoute: ProfileScreen.id,
    );
  }
}
