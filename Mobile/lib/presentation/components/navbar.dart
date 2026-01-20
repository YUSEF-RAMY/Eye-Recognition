import 'dart:ui';

import 'package:eye_recognition/presentation/screens/home_screen/home_screen.dart';
import 'package:eye_recognition/presentation/screens/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';

import 'navbar_icon.dart';

class Navbar extends StatelessWidget {
  Navbar({super.key, required this.isHome, required this.isProfile});

  bool isHome;
  bool isProfile;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 25 * 0.57735 + 0.5,
              sigmaY: 25 * 0.57735 + 0.5,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color(0xffD8E6FF).withValues(alpha: 0.9),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      NavbarIcon(
                        icon: Icons.home_outlined,
                        screenName: 'home',
                        isSelected: isHome,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 16),
                      NavbarIcon(
                        icon: Icons.person_outline_rounded,
                        screenName: 'profile',
                        isSelected: isProfile,
                        onTap: () {
                          Navigator.pushNamed(context, ProfileScreen.id);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
