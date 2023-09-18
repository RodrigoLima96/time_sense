// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:time_sense/src/shared/widgets/custom_app_bar.dart';

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
      appBar: CustomAppBar(
          icon: 'assets/icons/menu-icon.svg',
          function: () {
            openDrawer();
          }),
      body: const HomeBody(),
      drawer: const HomePageDrawer(),
    );
  }
}
