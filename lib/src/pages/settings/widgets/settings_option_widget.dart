// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/utils/utils.dart';

class SettingsOptionWidget extends StatelessWidget {
  final String text;
  final String setting;
  final Function funtion;

  const SettingsOptionWidget({
    super.key,
    required this.text,
    required this.setting,
    required this.funtion,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.9,
      height: size.height * 0.06,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: secondaryColor,
      ),
      child: GestureDetector(
        child: Container(
          margin: const EdgeInsets.only(left: 30, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text, style: textBold),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 15),
                    child: Text(setting, style: textBold),
                  ),
                  Transform.rotate(
                    angle: 4.68,
                    child: SvgPicture.asset(
                      'assets/icons/arrow-back-icon.svg',
                      color: primaryColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        onTap: () {
          funtion();
        },
      ),
    );
  }
}
