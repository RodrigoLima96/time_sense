// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../controllers/controllers.dart';
import '../utils/utils.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String icon;
  final Function function;

  const CustomAppBar({super.key, required this.icon, required this.function});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final pomodoroController = context.watch<PomodoroController>();

    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor,
      centerTitle: false,
      leadingWidth: 60,
      leading: Container(
        child: pomodoroController.showMenuButton
            ? InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.only(left: 5, top: 5),
                  margin: const EdgeInsets.all(15),
                  child: SvgPicture.asset(
                    icon,
                    color: primaryColor,
                  ),
                ),
                onTap: () {
                  function();
                },
              )
            : const SizedBox(),
      ),
    );
  }
}
