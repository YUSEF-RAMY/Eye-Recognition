import 'dart:developer';
import 'dart:io';
import 'package:eye_recognition/data/models/user_model.dart';
import 'package:eye_recognition/data/requests/logout_request.dart';
import 'package:eye_recognition/data/requests/update_profile_image_request.dart';
import 'package:eye_recognition/data/responses/get_user_info_response.dart';
import 'package:eye_recognition/main.dart';
import 'package:eye_recognition/presentation/components/custom_button.dart';
import 'package:eye_recognition/presentation/components/navbar.dart';
import 'package:eye_recognition/presentation/resources/color_manager.dart';
import 'package:eye_recognition/presentation/screens/change_password_screen/change_password_screen.dart';
import 'package:eye_recognition/presentation/screens/welcome_screen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../resources/image_manager.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  static String id = 'ProfileScreen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserModel> _userFuture;
  UserModel? user;
  late File image;
  late String imagePath = user!.image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _userFuture = getUserInfo();
  }

  Future<UserModel> getUserInfo() async {
    user = await GetUserInfoResponse().getUserInfoResponse();
    return user!;
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: SafeArea(
        child: FutureBuilder<UserModel>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: ColorManager.white),
              );
            }
            if (snapshot.hasError) {
              log(snapshot.error.toString());
              return Center(
                child: Text(
                  'there was an error',
                  style: TextStyle(color: ColorManager.white),
                ),
              );
            }
            final user = snapshot.data!;
            return Padding(
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
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xff9BBEFF).withValues(alpha: 0.75),
                          Color(0xff8F78FF).withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        await pickImage(ImageSource.gallery);
                        EyeRecognition.success = false;
                        log(EyeRecognition.token);
                        log(image.path);
                        imagePath = await UpdateProfileImageRequest()
                            .updateProfileImageRequest(imageFile: image);
                        if (EyeRecognition.success == true) {
                          setState(() {});
                        }
                      },
                      child: ClipOval(
                        child: Image.network(
                          imagePath,
                          width: 144,
                          height: 144,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              ImageManager.user,
                              width: 132,
                              height: 132,
                              fit: BoxFit.cover,
                              color: ColorManager.white,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    user.name,
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
                                user.name,
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
                                user.email,
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
                    onTap: () {
                      Navigator.pushNamed(context, ChangePasswordScreen.id);
                    },
                    isWhite: true,
                    isPrimaryTextColor: false,
                    isTransparent: true,
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    text: 'Logout',
                    onTap: () async {
                      await LogoutRequest().logoutRequest();
                      if (EyeRecognition.success == true) {
                        Navigator.pushReplacementNamed(
                          context,
                          WelcomeScreen.id,
                        );
                      }
                    },
                    isWhite: true,
                    isPrimaryTextColor: false,
                    isTransparent: false,
                  ),
                  Spacer(flex: 3),
                  Navbar(isHome: false, isProfile: true),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
