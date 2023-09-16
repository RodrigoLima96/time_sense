// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:time_sense/src/pages/home/widgets/drawer_icon.dart';

import '../../../shared/utils/utils.dart';

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
              onTap: () {},
            ),
            const SizedBox(height: 30),
            GestureDetector(
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor, width: 2.5),
                    ),
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        'https://lh3.googleusercontent.com/a/ACg8ocLaTq8NZFKl6beN5lRJwu5wUK7oumdHghVdQBwVEuZMayw=s288-c-no',
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: const Text(
                      'Perfil',
                      style: textBold,
                    ),
                  )
                ],
              ),
              onTap: () {},
            ),
            DrawerIcon(
              icon: 'assets/icons/tasks-icon.svg',
              text: 'Tarefas',
              press: () {},
            ),
            DrawerIcon(
              icon: 'assets/icons/settings-icon.svg',
              text: 'Configurações',
              press: () {},
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
