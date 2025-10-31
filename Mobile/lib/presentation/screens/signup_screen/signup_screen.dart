import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../data/requests/signup_request.dart';
import '../../../main.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';
import '../../resources/color_manager.dart';
import '../../resources/image_manager.dart';
import '../home_screen/home_screen.dart';
import '../login_screen/login_screen.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  static String id = 'SignupScreen';
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    Object? object = ModalRoute.of(context)!.settings.arguments;
    File? image = object == null? null : object as File;
    return Scaffold(
      backgroundColor: ColorManager.backgroundColor,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(ImageManager.BackgroundImage, fit: BoxFit.cover),
          ),
          Positioned(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.68,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                color: ColorManager.white,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: 42),
                    Text(
                      'Get Started',
                      style: TextStyle(
                        color: ColorManager.primaryTextColor,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacer(flex: 3),
                    CustomTextField(
                      labelText: 'Full name',
                      hintText: 'Entre username',
                      controller: userNameController,
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      labelText: 'Email',
                      hintText: 'Entre email',
                      controller: emailController,
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      labelText: 'Password',
                      hintText: 'Entre Password',
                      controller: passwordController,
                      isSecureText: true,
                      obscureText: true,
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      labelText: 'Confirm password',
                      hintText: 'Entre Password again',
                      controller: confirmPasswordController,
                      isSecureText: true,
                      obscureText: true,
                    ),
                    Spacer(flex: 7),
                    CustomButton(
                      text: 'Signup',
                      isWhite: false,
                      isTransparent: false,
                      isPrimaryTextColor: false,
                      onTap: () async {
                        log(
                          'email: ${emailController.text} \n password: ${passwordController.text}',
                        );
                        String token = await SignupRequest().signupRequest(
                          userName: userNameController.text,
                          email: emailController.text,
                          imageFile: image,
                          password: passwordController.text,
                          confirmPassword: confirmPasswordController.text,
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
                            'Already i have an account? ',
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
                                LoginScreen.id,
                              );
                            },
                            child: Text(
                              ' Login',
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
