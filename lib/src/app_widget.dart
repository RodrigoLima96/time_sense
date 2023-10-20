import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routes/routes.dart';
import 'controllers/controllers.dart';
import 'repositories/repositories.dart';
import 'services/services.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => InitDatabaseService.instance),
        Provider(create: (context) => DatabaseService(context.read())),
        Provider(create: (context) => PomodoroRepository(context.read())),
        Provider(create: (context) => SettingsRepository(context.read())),
        Provider(create: (context) => TaskRepository(context.read())),
        Provider(create: (context) => NotificationService()),
        ChangeNotifierProvider(create: (context) => PomodoroController(context.read(), context.read())),
        ChangeNotifierProvider(create: (context) => TasksController(context.read())),
        ChangeNotifierProvider(create: (context) => SettingsController(context.read())),
      ],
      child:  MaterialApp(
        title: 'Time Sense',
        debugShowCheckedModeBanner: false,
        routes: AppRoutes.list,
        initialRoute: AppRoutes.initial,
        navigatorKey: AppRoutes.navigatorKey,
      ),
    );
  }
}
