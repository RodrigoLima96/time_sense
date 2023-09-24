// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../shared/utils/utils.dart';

class TaskContainerBottomSheet extends StatelessWidget {
  final Function press;
  final String text;
  final String backIcon;

  const TaskContainerBottomSheet({
    super.key,
    required this.press,
    required this.text,
    required this.backIcon,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.8,
      height: size.height * 0.05,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: secondaryColor,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width * 0.55,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      text,
                      style: textBold,
                    ),
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            child: SvgPicture.asset(
              backIcon,
              color: primaryColor,
            ),
            onTap: () async {
              await press();
            },
          ),
        ],
      ),
    );
  }
}
