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
            child: Image.asset(
              ImageManager.loginAndSignupBackgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  //image box is here
                  height: 358,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                  child: Image.file(HomeScreen.image, fit: BoxFit.cover),
                ),
                SizedBox(height: 58),
                Positioned(
                  child: Container(
                    width: double.infinity,
                    height: 326,
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
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            //this text widget for the person name
                            'This eye for :- Dr.Mahmoud',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          CustomButton(
                            text: 'Try again',
                            isWhite: false,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
