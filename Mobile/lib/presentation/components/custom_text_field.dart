import 'package:flutter/material.dart';
import '../resources/color_manager.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.controller,
    this.obscureText = false,
    this.isSecureText = false,
  });

  String? hintText;
  String? labelText;

  //final ValueChanged<String> onchaned;
  final controller;
  bool obscureText;
  bool isSecureText;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorManager.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: ColorManager.gray, width: 1.3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: ColorManager.gray, width: 1.3),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: ColorManager.gray, width: 1.3),
        ),
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: ColorManager.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: ColorManager.secondTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: widget.isSecureText
            ? IconButton(
                onPressed: () {
                  widget.obscureText = widget.obscureText == false
                      ? true
                      : false;
                  setState(() {});
                },
                icon: Icon(
                  widget.obscureText?Icons.visibility_off_rounded:Icons.visibility_rounded,
                  size: 24,
                  color: ColorManager.black,
                ),
              )
            : null,
      ),
    );
  }
}
