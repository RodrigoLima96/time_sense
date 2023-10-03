import 'package:flutter/material.dart';

import '../utils/utils.dart';

class TotalFocusingTimeWidget extends StatelessWidget {
  final int hours;
  final int minutes;
  final int seconds;
  final int totalSeconds;
  final String text;
  final bool taskPending;

  const TotalFocusingTimeWidget({
    super.key,
    required this.hours,
    required this.minutes,
    required this.totalSeconds,
    required this.seconds,
    required this.text,
    required this.taskPending,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: hours < 1 && minutes < 1 && totalSeconds < 1
              ? const SizedBox()
              : Text(text, style: textRegular),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            hours > 0
                ? Text('$hours  ',
                    style: textBold.copyWith(color: primaryColor))
                : const SizedBox(),
            hours > 0
                ? Text(hours > 1 ? 'horas e  ' : 'hora e  ', style: textRegular)
                : const SizedBox(),
            minutes > 0
                ? Text('$minutes  ',
                    style: textBold.copyWith(color: primaryColor))
                : const SizedBox(),
            minutes > 0
                ? Text(minutes > 1 ? 'minutos' : 'minuto', style: textRegular)
                : const SizedBox(),
            seconds > 0 && totalSeconds > 60 ?
            Text(' $seconds ', style: textBold.copyWith(color: primaryColor)) : const SizedBox(),
            seconds > 0 && totalSeconds > 60 ?
            Text(seconds > 1 ? 'segundos' : 'segundo', style: textRegular) : const SizedBox(),
            totalSeconds > 0 && totalSeconds < 60
                ? Text('$totalSeconds ',
                    style: textBold.copyWith(color: primaryColor))
                : const SizedBox(),
            totalSeconds > 0 && totalSeconds < 60
                ? Text(totalSeconds > 1 ? 'segundos' : 'segundo',
                    style: textRegular)
                : const SizedBox(),
            hours < 1 && minutes < 1 && totalSeconds < 1
                ? Text(
                    taskPending
                        ? 'Tarefa não iniciada'
                        : 'Concluída sem tempo de foco',
                    style: textBold,
                  )
                : const SizedBox(),
          ],
        ),
      ],
    );
  }
}
