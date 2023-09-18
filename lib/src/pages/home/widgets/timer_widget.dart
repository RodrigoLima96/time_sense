import 'package:flutter/material.dart';
import '../../../shared/utils/utils.dart';

class TimerWidget extends StatefulWidget {
  final Duration timer;

  const TimerWidget({super.key, required this.timer});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.8,
      height: size.height * 0.35,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: Border.all(
          color: primaryColor,
          width: 8,
        ),
      ),
      child: Center(
        child: Text(
          '10:00',
          style: textBold.copyWith(
            fontSize: size.height * 0.06,
          ),
        ),
      ),
    );
  }
}
