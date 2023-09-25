import 'package:flutter/material.dart';

import '../../../../shared/utils/utils.dart';

class Session extends StatelessWidget {
  final String status;
  final bool lastSession;

  const Session({super.key, required this.status, required this.lastSession});

  @override
  Widget build(BuildContext context) {
    final Color color = status == 'complete' ? primaryColor : secondaryColor;
    final bool running = status == 'running' ? true : false;

    double sessionHeight = status != 'running' ? 13 : 20;
    double sessionWidth = status != 'running' ? 13 : 20;

    return Row(
      children: [
        Container(
          height: sessionHeight,
          width: sessionWidth,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: running
                ? Border.all(
                    color: primaryColor,
                    width: 2,
                  )
                : null,
          ),
        ),
        !lastSession ?
        Container(
          height: 3,
          width: 10,
          color: primaryColor,
        ) : Container(),
      ],
    );
  }
}
