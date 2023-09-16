// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/utils.dart';

class TaskContainer extends StatelessWidget {
  final Function press;
  final String completeOrRestoreIcon;
  final String backIcon;

  const TaskContainer(
      {super.key,
      required this.press,
      required this.completeOrRestoreIcon,
      required this.backIcon});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.8,
      height: size.height * 0.08,
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
                GestureDetector(
                  child: completeOrRestoreIcon.isEmpty
                      ? Container(
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: secondaryColor,
                            border: Border.all(
                              color: primaryColor,
                              width: 2,
                            ),
                          ),
                        )
                      : SvgPicture.asset(
                          'assets/icons/$completeOrRestoreIcon.svg',
                          color: primaryColor,
                          width: 27,
                        ),
                  onTap: () {},
                ),
                Container(
                  width: size.width * 0.6,
                  padding: const EdgeInsets.only(left: 12),
                  child: const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      'Estudar programação orientada a objetos',
                      style: textBold,
                    ),
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            child: SvgPicture.asset(
              'assets/icons/$backIcon.svg',
              color: primaryColor,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

// TaskContainer(
//               completeOrRestoreIcon: '',
//               backIcon: 'exit-icon',
//               press: () {},
//             ),