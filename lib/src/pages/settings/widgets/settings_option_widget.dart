// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/utils/utils.dart';
import 'widgets.dart';

class SettingsOptionWidget extends StatelessWidget {
  final String text;
  final String setting;
  final Function funtion;
  final double height;
  final double width;
  final bool showDetails;
  final double margin;

  const SettingsOptionWidget({
    super.key,
    required this.text,
    required this.setting,
    required this.funtion,
    required this.height,
    required this.width,
    required this.showDetails,
    this.margin = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          width: width,
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
                      setting.isNotEmpty
                          ? Container(
                              margin: const EdgeInsets.only(right: 15),
                              child: Text(setting, style: textBold),
                            )
                          : const SizedBox(),
                      Transform.rotate(
                        angle: 4.68,
                        child: SizedBox(
                          width: 50,
                          child: SvgPicture.asset(
                            'assets/icons/arrow-back-icon.svg',
                            color: primaryColor,
                          ),
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
        ),
        showDetails
            ? const ChangeSettingValueWidget(
                currentValue: 60,
                settingType: 'pomodoroTime',
              )
            : const SizedBox(),
        SizedBox(height: showDetails ? 0 : margin),
      ],
    );
  }
}
