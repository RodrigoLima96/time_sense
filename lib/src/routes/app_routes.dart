import 'package:flutter/material.dart';
import 'package:time_sense/src/pages/pages.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    '/home': (_) => const HomePage(),
    '/settings': (_) => const SettingsPage(),
    '/tasks': (_) => const TasksPage(),
    '/user': (_) => const UserPage(),
  };

  static String initial = '/home';

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
