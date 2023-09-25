import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import 'src/app_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  runApp(const MyApp());
}