import 'package:flutter/material.dart';
import '../resources/color_manager.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.isWhite,
    required this.isPrimaryTextColor,
    required this.isTransparent,
  });

  final VoidCallback onTap;
  String text;
  bool isWhite;
  bool isPrimaryTextColor;
  bool isTransparent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: isWhite && isTransparent
              ? Colors.transparent
              : isWhite
              ? ColorManager.white
              : isPrimaryTextColor
              ? ColorManager.primaryTextColor
              : isTransparent
              ? Colors.transparent
              : ColorManager.primary,
          borderRadius: BorderRadius.circular(16.0),
          border: BoxBorder.all(
            width: isTransparent ? 2 : 0,
            color: isWhite ? ColorManager.white : ColorManager.primary,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isTransparent && isWhite
                ? ColorManager.white
                : isTransparent && !isWhite || isWhite && !isTransparent
                ? ColorManager.primary
                : ColorManager.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
