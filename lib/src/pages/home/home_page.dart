// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../shared/utils/utils.dart';
import 'widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    void openDrawer() {
      scaffoldKey.currentState?.openDrawer();
    }
    
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/menu-icon.svg',
            color: primaryColor,
          ),
          onPressed: () {
            openDrawer();
          },
        ),
      ),
      body: const HomeBody(),
      drawer: const HomePageDrawer(),
    );
  }
}
