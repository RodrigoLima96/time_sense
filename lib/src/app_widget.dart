import 'package:flutter/material.dart';

import 'pages/pages.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Time Sense',
      debugShowCheckedModeBanner: false,
      home: HomePage()
    );
  }
}
