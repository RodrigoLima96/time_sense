import 'package:flutter/material.dart';

import 'widgets.dart';

class SessionsWidget extends StatelessWidget {
  final List<String> sessions;
  const SessionsWidget({super.key, required this.sessions});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            sessions.length,
             (index) {
              final isLast = index == sessions.length - 1;
              return Session(status: sessions[index], lastSession: isLast);
            },
          ),
        ),
      ],
    );
  }
}
