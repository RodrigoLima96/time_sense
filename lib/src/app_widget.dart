import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/controllers.dart';
import 'pages/pages.dart';
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
        ChangeNotifierProvider(create: (context) => PomodoroController(context.read())),
      ],
      child: const MaterialApp(
        title: 'Time Sense',
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
