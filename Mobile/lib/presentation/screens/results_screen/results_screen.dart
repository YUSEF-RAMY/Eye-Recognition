import 'package:eye_recognition/presentation/components/custom_button.dart';
import 'package:eye_recognition/presentation/resources/color_manager.dart';
import 'package:eye_recognition/presentation/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';

import '../../resources/image_manager.dart';

class ResultsScreen extends StatelessWidget {
  ResultsScreen({super.key});

  static String id = 'ResultsScreen';

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
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: MediaQuery.of(context).size.width-32,
                height: 336,
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Result : ',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        //this text widget for the person name
                        ModalRoute.of(context)!.settings.arguments.toString(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      CustomButton(
                        text: 'Try again',
                        isWhite: false,
                        isPrimaryTextColor: false,
                        isTransparent: false,
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            HomeScreen.id,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
