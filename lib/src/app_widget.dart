import 'package:flutter/material.dart';

import 'shared/utils/utils.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Sense',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: primaryColor,
                width: 50,
                height: 50,
              ),
              const SizedBox(height: 50),
              Container(
                color: secondaryColor,
                width: 50,
                height: 50,
              ),
              const SizedBox(height: 50),
              const Text(
                'text text text',
                style: textBold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
