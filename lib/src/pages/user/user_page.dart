// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../shared/utils/utils.dart';
import '../../shared/widgets/widgets.dart';
import 'widgets/widgets.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        icon: 'assets/icons/arrow-back-icon.svg',
        function: () {
          Navigator.pop(context);
        },
      ),
      body: const UserBody(),
    );
  }
}
