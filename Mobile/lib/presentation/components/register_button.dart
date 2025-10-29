import 'package:eye_recognition/presentation/screens/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import '../resources/color_manager.dart';
import '../screens/upload_profile_photo_screen/upload_profile_photo_screen.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    super.key,
    required this.text,
    required this.borderRadiusRight,
    required this.isSignup,
  });

  final String text;
  final bool borderRadiusRight;
  final bool isSignup;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isSignup
            ? Navigator.pushReplacementNamed(context, SignupScreen.id)
            : Navigator.pushReplacementNamed(context, LoginScreen.id);
      },
      child: Container(
        height: 92,
        width: MediaQuery.of(context).size.width * 0.5,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSignup ? ColorManager.white : Colors.transparent,
          borderRadius: borderRadiusRight
              ? BorderRadius.only(topRight: Radius.circular(50))
              : BorderRadius.only(topLeft: Radius.circular(50)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSignup
                ? ColorManager.primaryTextColor
                : ColorManager.white,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
