import 'package:flutter/material.dart';

import '../../../shared/utils/utils.dart';

class TimerWidget extends StatelessWidget {
  final Duration timer;

  const TimerWidget({super.key, required this.timer});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 275,
      height: 275,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: Border.all(
          color: primaryColor,
          width: 8,
        ),
      ),
      child:  Center(
        child: Text(
          '10:00',
          style: textBold.copyWith(
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}
