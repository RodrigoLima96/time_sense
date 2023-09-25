// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '/src/shared/utils/utils.dart';
import '/src/controllers/controllers.dart';

class ChangeSettingValueWidget extends StatefulWidget {
  final int currentValue;
  final String settingType;
  const ChangeSettingValueWidget({
    super.key,
    required this.currentValue,
    required this.settingType,
  });

  @override
  State<ChangeSettingValueWidget> createState() =>
      _ChangeSettingValueWidgetState();
}

class _ChangeSettingValueWidgetState extends State<ChangeSettingValueWidget> {
  bool isLongPressing = false;
  Timer? longPressTimer;

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              settingsController.changeSettingValue(
                  settingType: widget.settingType, action: 'decrement');
            },
            onLongPress: () {
              isLongPressing = true;
              longPressTimer =
                  Timer.periodic(const Duration(milliseconds: 50), (timer) {
                if (isLongPressing) {
                  settingsController.changeSettingValue(
                      settingType: widget.settingType, action: 'decrement');
                } else {
                  timer.cancel();
                }
              });
            },
            onLongPressEnd: (LongPressEndDetails longPressEndDetails) {
              isLongPressing = false;
              longPressTimer?.cancel();
            },
            child: Container(
              width: 60,
              height: 60,
              color: Colors.transparent,
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/minus-icon.svg',
                  color: primaryColor,
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 50),
          Text(
            settingsController.selectedSettingOptionValue.toString(),
            style: textBold.copyWith(fontSize: 30),
          ),
          const SizedBox(width: 50),
          GestureDetector(
            onTap: () {
              settingsController.changeSettingValue(
                  settingType: widget.settingType, action: 'increment');
            },
            onLongPress: () {
              isLongPressing = true;
              longPressTimer =
                  Timer.periodic(const Duration(milliseconds: 50), (timer) {
                if (isLongPressing) {
                  settingsController.changeSettingValue(
                      settingType: widget.settingType, action: 'increment');
                } else {
                  timer.cancel();
                }
              });
            },
            onLongPressEnd: (LongPressEndDetails longPressEndDetails) {
              isLongPressing = false;
              longPressTimer?.cancel();
            },
            child: Container(
              width: 60,
              height: 60,
              color: Colors.transparent,
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/more-icon.svg',
                  color: primaryColor,
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
