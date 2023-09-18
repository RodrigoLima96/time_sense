// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:time_sense/src/pages/user/widgets/widgets.dart';

import '../../shared/utils/utils.dart';
import 'widgets/settings_body.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        icon: 'assets/icons/arrow-back-icon.svg',
        function: () => Navigator.of(context).pop(),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        child: const SettingsBody(),
      ),
    );
  }
}
