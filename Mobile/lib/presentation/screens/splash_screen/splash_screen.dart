import 'package:eye_recognition/presentation/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../resources/image_manager.dart';
import '../welcome_screen/welcome_screen.dart';

bool? frist = true;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static String id = 'SplashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 6), () {
      Navigator.pushReplacementNamed(context, WelcomeScreen.id);
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: ColorManager.primary),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImageManager.logo, width: 170, height: 115),
            Text(
              'Eye Recognition',
              style: TextStyle(
                color: ColorManager.white,
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
