// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/utils.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String icon;
  final Function function;

  const CustomAppBar({super.key, required this.icon, required this.function});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor,
      centerTitle: false,
      leadingWidth: 40,
      leading: Container(
        margin: const EdgeInsets.only(left: 15),
        child: GestureDetector(
          child: SvgPicture.asset(
            icon,
            color: primaryColor,
          ),
          onTap: () {
            function();
          },
        ),
      ),
    );
  }
}
