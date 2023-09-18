import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/controllers.dart';
import 'pages/pages.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PomodoroController()),
      ],
      child: const MaterialApp(
          title: 'Time Sense',
          debugShowCheckedModeBanner: false,
          home: HomePage()),
    );
  }
}
