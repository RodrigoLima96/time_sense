import 'package:flutter/material.dart';

import '../utils/utils.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.press,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: color,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        child: Center(
          child: Text(
            text,
            style: textBold,
          ),
        ),
      ),
    ),
    onTap: () {
      press();
    },
  );
  }
}


// Container(
//       width: 200,
//       height: 200,
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: Colors.black,
//           width: 5.0,
//           style: BorderStyle.solid,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         color: Colors.yellowAccent,
//       ),
//       child: const Center(child: Text('Hello World')),
//     );
