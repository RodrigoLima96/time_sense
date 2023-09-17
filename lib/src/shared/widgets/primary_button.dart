// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/utils.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color;
  final double height;
  final double? width;
  final String? backIcon;
  const PrimaryButton({
    super.key,
    required this.text,
    required this.press,
    required this.color,
    required this.height,
    this.width,
    this.backIcon,
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
          padding:
              EdgeInsets.symmetric(horizontal: widteWidth, vertical: height),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (backIcon != null)
                const SizedBox(width: 8.0), // Espaço entre o ícone e o texto
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white, // Cor do texto
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (backIcon != null)
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Transform.rotate(
                      angle: 4.68,
                    child: SvgPicture.asset(
                      backIcon!,
                      color: primaryColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      onTap: () {
        press();
      },
    );
  }
}
