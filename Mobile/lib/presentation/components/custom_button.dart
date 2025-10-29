import 'package:flutter/material.dart';
import '../resources/color_manager.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    required this.text,
    required this.isWhite,
    this.isHomeButton = false,
    required this.onTap,
  });

  final VoidCallback onTap;
  String text;
  bool isWhite;
  bool isHomeButton;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: isWhite
              ? ColorManager.white
              : isHomeButton
              ? ColorManager.primaryTextColor
              : ColorManager.primary,
          borderRadius: BorderRadius.circular(16.0),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isWhite ? ColorManager.black : ColorManager.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
