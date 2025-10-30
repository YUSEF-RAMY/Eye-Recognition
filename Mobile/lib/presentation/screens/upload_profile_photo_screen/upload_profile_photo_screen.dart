import 'package:eye_recognition/presentation/components/custom_button.dart';
import 'package:eye_recognition/presentation/screens/signup_screen/signup_screen.dart';
import 'package:flutter/material.dart';

import '../../resources/color_manager.dart';
import '../../resources/image_manager.dart';

class UploadProfilePhotoScreen extends StatefulWidget {
  const UploadProfilePhotoScreen({super.key});

  static String id = 'UploadProfilePhotoScreen';

  @override
  State<UploadProfilePhotoScreen> createState() =>
      _UploadProfilePhotoScreenState();
}

class _UploadProfilePhotoScreenState extends State<UploadProfilePhotoScreen> {
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          onTap: () {},
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
                          onTap: () {}, //upload profile photo request
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
