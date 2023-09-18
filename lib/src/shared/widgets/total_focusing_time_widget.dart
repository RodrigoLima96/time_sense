import 'package:flutter/material.dart';

import '../utils/utils.dart';

class TotalFocusingTimeWidget extends StatelessWidget {
  final int hours;
  final int minutes;
  final String text;

  const TotalFocusingTimeWidget({
    super.key,
    required this.hours,
    required this.minutes,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(text, style: textRegular),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$hours  ', style: textBold.copyWith(color: primaryColor)),
            const Text('horas e  ', style: textRegular),
            Text('$minutes  ', style: textBold.copyWith(color: primaryColor)),
            const Text('minutos', style: textRegular),
          ],
        ),
      ],
    );
  }
}
