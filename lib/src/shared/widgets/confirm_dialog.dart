// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:time_sense/src/shared/utils/constants.dart';

import 'widgets.dart';

Future<void> showDeleteConfirmationDialog({
  required BuildContext context,
  required Function confirmFunction,
  required Function deniedFunction,
  Map<String, int>? taskTime,
  String? icon,
  required String text,
}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        backgroundColor: primaryColor,
        titlePadding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        title: icon != null
            ? SvgPicture.asset(icon, color: Colors.red.shade300)
                .animate()
                .shake(delay: 300.ms, rotation: 0.5)
            : Text(text, style: textRegular),
        content: icon == null
            ? SizedBox(
                height: 50,
                child: TotalFocusingTimeWidget(
                  hours: taskTime!['hour']!,
                  minutes: taskTime['minutes']!,
                  totalSeconds: taskTime['totalSeconds']!,
                  seconds: taskTime['seconds']!,
                  text: 'Focus time',
                  taskPending: true,
                  removePomodoroTask: true,
                ),
              )
            : Text(text, style: textRegular),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                child: const Text('No', style: textBold),
                onPressed: () {
                  deniedFunction();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Yes', style: textBold),
                onPressed: () {
                  confirmFunction();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ).animate().scale().fade();
    },
  );
}
