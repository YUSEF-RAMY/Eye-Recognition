import 'package:eye_recognition/presentation/components/custom_button.dart';
import 'package:eye_recognition/presentation/components/navbar.dart';
import 'package:eye_recognition/presentation/resources/color_manager.dart';
import 'package:flutter/material.dart';
import '../../resources/image_manager.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static String id = 'ProfileScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: 12),
              Text(
                'Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: ColorManager.white,
                ),
              ),
              SizedBox(height: 24),
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
                    color: ColorManager.white,
                  ),
                ), //user image
              ),
              SizedBox(height: 8),
              Text(
                'maryam mahmoud',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: ColorManager.white,
                ),
              ),
              Spacer(flex: 2),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xff1F336D),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Name:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: ColorManager.white,
                            ),
                          ),
                          Text(
                            'maryam mahmoud',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: ColorManager.white,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: ColorManager.white.withValues(alpha: 0.5),
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Email:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: ColorManager.white,
                            ),
                          ),
                          Text(
                            'maryam@gmail.com',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: ColorManager.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(flex: 5),
              CustomButton(
                text: 'Change password',
                onTap: () {},
                isWhite: true,
                isPrimaryTextColor: false,
                isTransparent: true,
              ),
              SizedBox(height: 20),
              CustomButton(
                text: 'Logout',
                onTap: () {},
                isWhite: true,
                isPrimaryTextColor: false,
                isTransparent: false,
              ),
              Spacer(flex: 3),
              Navbar(isHome: false,isProfile: true,),
            ],
          ),
        ),
      ),
    );
  }
}
