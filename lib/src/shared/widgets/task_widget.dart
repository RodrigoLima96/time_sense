// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '/src/models/models.dart';

import '../utils/utils.dart';
import 'widgets.dart';

class TaskWidget extends StatelessWidget {
  final Task task;
  final String frontIcon;
  final String backIcon;
  final Function frontFunction;
  final Function widgetFunction;
  final Function backFunction;
  final bool showFrontIcon;
  final bool pomodoroTask;
  final bool isPending;

  const TaskWidget({
    super.key,
    required this.frontIcon,
    required this.backIcon,
    required this.frontFunction,
    required this.backFunction,
    required this.widgetFunction,
    required this.task,
    required this.showFrontIcon,
    required this.pomodoroTask,
    required this.isPending,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Color widgetColor = task.showDetails ? primaryColor : secondaryColor;

    Color backIconColor = task.showDetails ? Colors.red.shade300 : primaryColor;

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
                    showFrontIcon || task.showDetails
                        ? GestureDetector(
                            child: Container(
                              height: 30,
                              width: 30,
                              color: Colors.transparent,
                              child: Center(
                                child: SvgPicture.asset(
                                  frontIcon,
                                  color: task.showDetails
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
                        width: task.showDetails || showFrontIcon
                            ? size.width * 0.65
                            : size.width * 0.72,
                        height: size.height * 0.05,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 12),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            task.text,
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
                      task.showDetails ? 'assets/icons/delete-icon.svg' : backIcon,
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
        task.showDetails
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
