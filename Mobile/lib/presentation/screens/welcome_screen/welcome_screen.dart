import 'package:eye_recognition/presentation/resources/color_manager.dart';
import 'package:flutter/material.dart';
import '../../components/register_button.dart';
import '../../resources/image_manager.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static String id = 'WelcomeScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundColor,
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              ImageManager.BackgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Spacer(),
              Text(
                'Welcome Back',
                style: TextStyle(
                  color: ColorManager.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 28),
              Text(
                'Enter personal \ndetails to you employee account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorManager.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Row(
                children: [
                  RegisterButton(
                    text: 'Login',
                    borderRadiusRight: true,
                    isSignup: false,
                  ),
                  RegisterButton(
                    text: 'Signup',
                    borderRadiusRight: false,
                    isSignup: true,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

