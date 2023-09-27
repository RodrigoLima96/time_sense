// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/utils.dart';
import 'widgets.dart';

class TaskWidget extends StatelessWidget {
  final String frontIcon;
  final String backIcon;
  final Color backIconColor;
  final String text;
  final bool showFrontIcon;
  final Color widgetColor;
  final bool showTaskDetails;
  final Function frontFunction;
  final Function widgetFunction;
  final Function backFunction;

  const TaskWidget({
    super.key,
    required this.frontIcon,
    required this.backIcon,
    required this.text,
    required this.showFrontIcon,
    required this.backIconColor,
    required this.widgetColor,
    required this.showTaskDetails,
    required this.frontFunction,
    required this.backFunction,
    required this.widgetFunction,
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
          padding: const EdgeInsets.symmetric(horizontal: 15),
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
                              height: 30,
                              width: 30,
                              color: Colors.transparent,
                              child: Center(
                                child: SvgPicture.asset(
                                  frontIcon,
                                  color: showTaskDetails
                                      ? Colors.black
                                      : primaryColor,
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                            onTap: () {
                              frontFunction();
                            },
                          )
                        : const SizedBox(),
                    InkWell(
                      child: Container(
                        width: size.width * 0.65,
                        height: size.height * 0.05,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 12),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            text,
                            style: textBold,
                          ),
                        ),
                      ),
                      onTap: () {
                        widgetFunction();
                      },
                    )
                  ],
                ),
              ),
              GestureDetector(
                child: Container(
                  height: 35,
                  width: 35,
                  color: Colors.transparent,
                  child: Center(
                    child: SvgPicture.asset(
                      backIcon,
                      color: backIconColor,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
                onTap: () {
                  backFunction();
                },
              ),
            ],
          ),
        ),
        showTaskDetails
            ? Container(
                margin: const EdgeInsets.only(top: 10),
                child: const TotalFocusingTimeWidget(
                  hours: 2,
                  minutes: 4,
                  text: 'Tempo de foco',
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
