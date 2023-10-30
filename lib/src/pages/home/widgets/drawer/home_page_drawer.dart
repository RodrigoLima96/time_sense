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
    Size size = MediaQuery.of(context).size;

    return Drawer(
      backgroundColor: backgroundColor,
      width: size.width * 0.6,
      elevation: 0,
      child: Container(
        margin: const EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            GestureDetector(
              child: SvgPicture.asset(
                'assets/icons/arrow-back-icon.svg',
                color: primaryColor,
                width: 20,
              ),
              onTap: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 30),
            DrawerIcon(
                icon: 'assets/icons/profile-icon.svg',
                text: 'Perfil',
                press: () {
                  Navigator.of(AppRoutes.navigatorKey!.currentContext!)
                      .pushNamed('/user');
                }),
            DrawerIcon(
              icon: 'assets/icons/tasks-icon.svg',
              text: 'Tarefas',
              press: () {
                Navigator.of(AppRoutes.navigatorKey!.currentContext!)
                    .pushNamed('/tasks');
              },
            ),
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
