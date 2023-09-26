// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../controllers/controllers.dart';
import '../../../shared/utils/utils.dart';
import 'widgets.dart';

class SettingsOptionWidget extends StatelessWidget {
  final String text;
  final String setting;
  final double margin;
  final String settingType;
  double? width;

  SettingsOptionWidget({
    super.key,
    required this.text,
    required this.setting,
    this.margin = 40,
    required this.settingType,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final settingsController = context.watch<SettingsController>();

    final bool showDetails =
        settingsController.showSettinsDetails(settingType: settingType);

    return Column(
      children: [
        Container(
          height: 40,
          width: width ?? size.width * 0.85,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: secondaryColor,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
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
                        angle: showDetails ? 4.68 : 3.2,
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
              settingsController.selectSettingOption(settingType: settingType);
            },
          ),
        ),
        showDetails
            ? ChangeSettingValueWidget(
                settingType: settingType,
              )
            : const SizedBox(),
        SizedBox(height: showDetails ? 0 : margin),
      ],
    );
  }
}
