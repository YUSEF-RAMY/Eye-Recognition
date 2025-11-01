import 'dart:developer';
import 'dart:io';
import 'package:eye_recognition/presentation/components/custom_button.dart';
import 'package:eye_recognition/presentation/screens/signup_screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../resources/color_manager.dart';
import '../../resources/image_manager.dart';
import '../login_screen/login_screen.dart';

class UploadProfilePhotoScreen extends StatefulWidget {
  UploadProfilePhotoScreen({super.key});

  static String id = 'UploadProfilePhotoScreen';
  late File image;

  @override
  State<UploadProfilePhotoScreen> createState() =>
      _UploadProfilePhotoScreenState();
}

class _UploadProfilePhotoScreenState extends State<UploadProfilePhotoScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        widget.image = File(pickedFile.path);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundColor,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
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
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 144,
                          width: 144,
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: AlignmentGeometry.topCenter,
                              end: AlignmentGeometry.bottomCenter,
                              colors: [
                                Color(0xff9BBEFF).withValues(alpha: 0.75),
                                Color(0xff8F78FF).withValues(alpha: 0.05),
                                //opacity: 0
                              ],
                            ),
                          ),
                          child: ClipOval(
                            //To cut picture on circle shape
                            child: Image.asset(
                              ImageManager.user,
                              width: 132,
                              height: 132,
                              fit: BoxFit.cover,
                            ),
                          ), //user image
                        ),
                        SizedBox(height: 40.0),
                        GestureDetector(
                          onTap: () async{
                            await pickImage(ImageSource.gallery);
                            log(widget.image.path);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              border: BoxBorder.all(
                                width: 1.4,
                                color: ColorManager.primary,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Upload profile picture',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Icon(
                                  Icons.drive_folder_upload_outlined,
                                  color: ColorManager.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        CustomButton(
                          text: 'Skip',
                          isWhite: false,
                          isPrimaryTextColor: false,
                          isTransparent: true,
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              SignupScreen.id,
                            );
                          },
                        ),
                        SizedBox(height: 12),
                        CustomButton(
                          text: 'Next',
                          isWhite: false,
                          isTransparent: false,
                          isPrimaryTextColor: false,
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              SignupScreen.id,
                              arguments: widget.image,
                            );
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
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
