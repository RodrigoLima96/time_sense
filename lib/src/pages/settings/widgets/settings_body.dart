// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:time_sense/src/pages/settings/widgets/widgets.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final double settignWidth = size.width * 0.9;
    final double settignHeight = size.height * 0.06;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SettingsOptionWidget(
            text: 'Tempo de foco',
            setting: '20 min',
            funtion: () {},
            height: settignHeight,
            width: settignWidth,
          ),
          const SizedBox(height: 40),
          SettingsOptionWidget(
            text: 'Pausa curta',
            setting: '5 min',
            funtion: () {},
            height: settignHeight,
            width: settignWidth,
          ),
          const SizedBox(height: 40),
          SettingsOptionWidget(
            text: 'Pausa longa',
            setting: '15 min',
            funtion: () {},
            height: settignHeight,
            width: settignWidth,
          ),
          const SizedBox(height: 40),
          SettingsOptionWidget(
            text: 'Sessões diárias',
            setting: '4',
            funtion: () {},
            height: settignHeight,
            width: settignWidth,
          ),
          const Spacer(),
          const SettingsOptionsButtons()
        ],
      ),
    );
  }
}
