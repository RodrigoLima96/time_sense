// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'widgets/widgets.dart';

import '../../shared/utils/utils.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        centerTitle: false,
        leadingWidth: 40,
        leading: Container(
          margin: const EdgeInsets.only(left: 15),
          child: GestureDetector(
            child: SvgPicture.asset(
              'assets/icons/arrow-back-icon.svg',
              color: primaryColor,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: const UserBody(),
    );
  }
}
