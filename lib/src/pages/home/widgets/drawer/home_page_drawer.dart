// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../shared/utils/utils.dart';

import '/src/routes/routes.dart';
import '/src/pages/home/widgets/widgets.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: backgroundColor,
      width: 200,
      elevation: 0,
      child: Container(
        margin: const EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                child: SvgPicture.asset(
                  'assets/icons/arrow-back-icon.svg',
                  color: primaryColor,
                  height: 20,
                ),
              ),
              onTap: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 50),
            DrawerIcon(
                icon: 'assets/icons/profile-icon.svg',
                text: 'Perfil',
                press: () {
                  Navigator.of(AppRoutes.navigatorKey!.currentContext!)
                      .pushNamed('/user');
                }),
            const SizedBox(height: 15),
            DrawerIcon(
              icon: 'assets/icons/tasks-icon.svg',
              text: 'Tarefas',
              press: () {
                Navigator.of(AppRoutes.navigatorKey!.currentContext!)
                    .pushNamed('/tasks');
              },
            ),
            const SizedBox(height: 15),
            DrawerIcon(
              icon: 'assets/icons/settings-icon.svg',
              text: 'Configurações',
              press: () {
                Navigator.of(AppRoutes.navigatorKey!.currentContext!)
                    .pushNamed('/settings');
              },
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: DrawerIcon(
                icon: 'assets/icons/exit-icon.svg',
                text: 'Sair',
                press: () {
                  SystemNavigator.pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
