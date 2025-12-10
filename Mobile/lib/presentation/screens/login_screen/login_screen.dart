import 'dart:developer';
import 'package:eye_recognition/data/requests/login_request.dart';
import 'package:eye_recognition/presentation/components/custom_button.dart';
import 'package:eye_recognition/presentation/components/custom_text_field.dart';
import 'package:eye_recognition/presentation/resources/image_manager.dart';
import 'package:eye_recognition/presentation/screens/home_screen/home_screen.dart';
import 'package:eye_recognition/presentation/screens/upload_profile_photo_screen/upload_profile_photo_screen.dart';
import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../resources/color_manager.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  static String id = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(ImageManager.BackgroundImage, fit: BoxFit.cover),
          ),
          SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height:
                  MediaQuery.of(context).size.height * 0.72 +
                  MediaQuery.of(context).viewInsets.bottom,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                color: ColorManager.white,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 42),
                    Text(
                      'Welcome back',
                      style: TextStyle(
                        color: ColorManager.primaryTextColor,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacer(flex: 3),
                    CustomTextField(
                      labelText: 'Email',
                      hintText: 'Entre Email',
                      controller: emailController,
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      labelText: 'password',
                      hintText: 'Entre Password',
                      controller: passwordController,
                      isSecureText: true,
                      obscureText: true,
                    ),
                    Spacer(flex: 7),
                    CustomButton(
                      text: 'Login',
                      isWhite: false,
                      isTransparent: false,
                      isPrimaryTextColor: false,
                      onTap: () async {
                        log(
                          'email: ${emailController.text} \n password: ${passwordController.text}',
                        );
                        String token = await LoginRequest().loginRequest(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        EyeRecognition.token = token;
                        log(token);
                        if (EyeRecognition.success == true) {
                          Navigator.pushReplacementNamed(
                            context,
                            HomeScreen.id,
                          );
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 60.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Don\'t have an acount? ',
                            style: TextStyle(
                              color: ColorManager.secondTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                UploadProfilePhotoScreen.id,
                              );
                            },
                            child: Text(
                              ' Signup',
                              style: TextStyle(
                                color: ColorManager.primaryTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
