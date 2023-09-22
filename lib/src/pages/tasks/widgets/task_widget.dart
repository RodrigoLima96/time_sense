// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/utils/utils.dart';
import '../../../shared/widgets/widgets.dart';

class TaskWidget extends StatelessWidget {
  final String frontIcon;
  final String backIcon;
  final Color backIconColor;
  final String text;
  final bool showFrontIcon;
  final Color widgetColor;
  final bool showTaskDetails;

  const TaskWidget({
    super.key,
    required this.frontIcon,
    required this.backIcon,
    required this.text,
    required this.showFrontIcon,
    required this.backIconColor,
    required this.widgetColor,
    required this.showTaskDetails
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          width: size.width * 0.9,
          height: size.height * 0.05,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: widgetColor,
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
                    showFrontIcon
                        ? GestureDetector(
                            child: Container(
                              height: 18,
                              width: 18,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: secondaryColor,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                            ),
                            onTap: () {},
                          )
                        : const SizedBox(),
                    Container(
                      width: size.width * 0.65,
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
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: SvgPicture.asset(
                    backIcon,
                    color: backIconColor,
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
        showTaskDetails ? Container(
          margin: const EdgeInsets.only(top: 10),
          child: const TotalFocusingTimeWidget(
              hours: 2,
              minutes: 4,
              text: 'Tempo de foco',
            ),
        ) : const SizedBox(),
      ],
    );
  }
}
