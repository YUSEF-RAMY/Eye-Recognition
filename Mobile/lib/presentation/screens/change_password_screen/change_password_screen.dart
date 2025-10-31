import 'dart:developer';

import 'package:eye_recognition/data/requests/update_password_request.dart';
import 'package:eye_recognition/main.dart';
import 'package:eye_recognition/presentation/components/custom_button.dart';
import 'package:eye_recognition/presentation/components/custom_text_field.dart';
import 'package:eye_recognition/presentation/resources/color_manager.dart';
import 'package:eye_recognition/presentation/screens/login_screen/login_screen.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  static String id = 'ChangePasswordScreen';

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ColorManager.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 24,
                    color: ColorManager.primary,
                  ),
                ),
              ),
              SizedBox(height: 42),
              Text(
                'Change password',
                style: TextStyle(
                  color: ColorManager.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Your password must be at least 6 characters and should include a combination of numbers, letters and special characters (!\$@%).',
                style: TextStyle(
                  color: ColorManager.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Spacer(flex: 1),
              CustomTextField(
                hintText: 'Current password',
                controller: currentPasswordController,
                obscureText: true,
                isSecureText: true,
                isWhite: true,
              ),
              SizedBox(height: 16),
              CustomTextField(
                hintText: 'new password',
                controller: newPasswordController,
                obscureText: true,
                isSecureText: true,
                isWhite: true,
              ),
              SizedBox(height: 16),
              CustomTextField(
                hintText: 'confirm new password',
                controller: confirmNewPasswordController,
                obscureText: true,
                isSecureText: true,
                isWhite: true,
              ),
              Spacer(flex: 2),
              CustomButton(
                text: 'save',
                onTap: () async {
                  log(
                    'currentPassword: ${currentPasswordController.text} \n newPassword: ${newPasswordController.text} \n confirmNewPassword: ${confirmNewPasswordController.text}',
                  );
                  String result = await UpdatePasswordRequest()
                      .updatePasswordRequest(
                        currentPassword: currentPasswordController.text,
                        newPassword: newPasswordController.text,
                        confirmNewPassword: confirmNewPasswordController.text,
                      );
                  if(EyeRecognition.success==true){
                    Navigator.pushReplacementNamed(context, LoginScreen.id);
                  }
                },
                isWhite: true,
                isPrimaryTextColor: false,
                isTransparent: true,
              ),
              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
