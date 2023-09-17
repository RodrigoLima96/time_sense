import 'package:flutter/material.dart';

import '../utils/utils.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color;
  final double height;
  final double? width;
  const PrimaryButton({
    super.key,
    required this.text,
    required this.press,
    required this.color,
    required this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final double widteWidth = width != null ? width! : 20;
    
    return GestureDetector(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: color,
          ),
          padding: EdgeInsets.symmetric(
              horizontal: widteWidth, vertical: height),
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
