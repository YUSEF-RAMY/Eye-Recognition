import 'package:flutter/material.dart';

import '../resources/color_manager.dart';

class NavbarIcon extends StatelessWidget {
  NavbarIcon({
    super.key,
    required this.icon,
    required this.screenName,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String screenName;
  bool isSelected;
  void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return isSelected
        ? Container(
            decoration: BoxDecoration(
              color: ColorManager.primary.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ColorManager.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 32),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 10.0),
                  child: Text(
                    screenName,
                    style: TextStyle(
                      color: ColorManager.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )
        : GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(width: 1.4, color: ColorManager.primary),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: ColorManager.primary, size: 32),
            ),
          );
  }
}
