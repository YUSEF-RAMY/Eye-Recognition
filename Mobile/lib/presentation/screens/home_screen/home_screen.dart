import 'dart:developer';
import 'dart:io';
import 'package:eye_recognition/data/requests/recognize_request.dart';
import 'package:eye_recognition/presentation/components/custom_button.dart';
import 'package:eye_recognition/presentation/screens/results_screen/results_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../main.dart';
import '../../components/navbar.dart';
import '../../resources/color_manager.dart';
import '../../resources/image_manager.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  static String id = 'HomeScreen';
  static late File image;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        HomeScreen.image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundColor,
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(ImageManager.BackgroundImage, fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Spacer(),
                  Text(
                    'Let\'s stared',
                    style: TextStyle(
                      color: ColorManager.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 28),
                  Text(
                    'To start recognition your eye you must Take photo OR choose photo',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      color: ColorManager.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  CustomButton(
                    text: 'Choose photo',
                    isWhite: true,
                    isTransparent: false,
                    isPrimaryTextColor: false,
                    onTap: () async {
                      await pickImage(ImageSource.gallery);
                      log(EyeRecognition.token);
                      log(HomeScreen.image.path);
                      String result = await RecognizeRequest().recognizeRequest(
                        imageFile: HomeScreen.image,
                      );
                      if (EyeRecognition.success == true) {
                        Navigator.pushReplacementNamed(context, ResultsScreen.id);
                      }
                    },
                  ),
                  SizedBox(height: 24),
                  CustomButton(
                    text: 'Take photo',
                    isWhite: false,
                    isTransparent: false,
                    isPrimaryTextColor: true,
                    onTap: () async {
                      await pickImage(ImageSource.camera);
                      log(EyeRecognition.token);
                      log(HomeScreen.image.path);
                      String result = await RecognizeRequest().recognizeRequest(
                        imageFile: HomeScreen.image,
                      );
                      if (EyeRecognition.success == true) {
                        Navigator.pushReplacementNamed(context, ResultsScreen.id);
                      }
                    },
                  ),
                  Spacer(),
                  Navbar(isHome: true,isProfile: false,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

