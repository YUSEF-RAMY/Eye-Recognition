import 'package:flutter/material.dart';
import '../resources/color_manager.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    required this.hintText,
    required this.labelText,
    required this.controller,
  });

  String? hintText;
  String? labelText;

  //final ValueChanged<String> onchaned;
  final controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorManager.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: ColorManager.gray,
            width: 1.3,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: ColorManager.gray,
            width: 1.3,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: ColorManager.gray,
            width: 1.3,
          ),
        ),
        labelText: labelText,
        labelStyle: TextStyle(
          color: ColorManager.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: ColorManager.secondTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
