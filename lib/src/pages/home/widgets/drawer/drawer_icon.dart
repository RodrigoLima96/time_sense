// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../shared/utils/utils.dart';

class DrawerIcon extends StatelessWidget {
  final String icon;
  final String text;
  final Function press;
  const DrawerIcon({
    super.key,
    required this.icon,
    required this.text,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              color: primaryColor,
              width: 20,
            ),
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: Text(
                text,
                style: textBold,
              ),
            )
          ],
        ),
      ),
      onTap: () {
        press();
      },
    );
  }
}
