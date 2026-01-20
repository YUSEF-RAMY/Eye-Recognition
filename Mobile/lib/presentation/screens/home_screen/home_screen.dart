import 'dart:developer';
import 'dart:io';
import 'package:eye_recognition/data/requests/recognize_request.dart';
import 'package:eye_recognition/presentation/components/custom_button.dart';
import 'package:eye_recognition/presentation/screens/camera_screen/camera_screen.dart';
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
  late File image;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
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
                    'To start recognition your eye you must Take photo',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      color: ColorManager.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  SizedBox(height: 24),
                  CustomButton(
                    text: 'Take photo',
                    isWhite: false,
                    isTransparent: false,
                    isPrimaryTextColor: true,
                    onTap: () async {
                      final File? capturedEyeFile = await Navigator.pushNamed(
                        context,
                        CameraWithOverlay.id,
                      );

                      if (capturedEyeFile == null) {
                        log("No image returned");
                        return;
                      }
                      widget.image = capturedEyeFile;

                      // خزّن الصورة في widget.image

                      log(widget.image.path);
                      EyeRecognition.success = false;
                      // ابعت الصورة للسيرفر/الـ backend
                      String name = await RecognizeRequest().recognizeRequest(
                        imageFile: widget.image,
                      );
                      log(EyeRecognition.success.toString());
                      if (EyeRecognition.success == true) {
                        Navigator.pushReplacementNamed(
                          context,
                          ResultsScreen.id,
                          arguments: name,
                        );
                      }
                    },
                  ),
                  Spacer(),
                  Navbar(isHome: true, isProfile: false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
