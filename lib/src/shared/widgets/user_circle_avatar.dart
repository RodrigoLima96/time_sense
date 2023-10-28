import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class UserCircleAvatar extends StatelessWidget {
  final List<int>? image;
  final double width;
  final double height;
  final double borderWidth;

  const UserCircleAvatar({
    super.key,
    required this.image,
    required this.width,
    required this.height,
    required this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: primaryColor, width: borderWidth),
      ),
      child: image != null
          ? CircleAvatar(
              radius: 20,
              backgroundColor: whiteColor,
              backgroundImage: MemoryImage(Uint8List.fromList(image!)))
          // AssetImage('assets/images/default_user.png'))
          : const CircleAvatar(
              radius: 20,
              backgroundColor: whiteColor,
              backgroundImage: AssetImage('assets/images/default_user.png'),
            ),
    );
  }
}
