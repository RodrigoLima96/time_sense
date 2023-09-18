// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/utils.dart';

class AddTaskWidget extends StatelessWidget {
  const AddTaskWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: size.width * 0.7,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Criar tarefa...',
              hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.normal),
              border: InputBorder.none,
            ),
            style: textBold,
          ),
        ),
        Transform.rotate(
          angle: -44.77,
          child: GestureDetector(
            child: SvgPicture.asset(
              'assets/icons/exit-icon.svg',
              color: primaryColor,
              width: 20,
            ),
            onTap: () {},
          ),
        )
      ],
    );
  }
}
