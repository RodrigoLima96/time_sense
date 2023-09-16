import 'package:flutter/material.dart';

import '../utils/utils.dart';

class UserCircleAvatar extends StatelessWidget {
  final String urlImage;
  final double width;
  final double height;

  const UserCircleAvatar({
    super.key,
    required this.urlImage,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: primaryColor, width: 2.5),
      ),
      child: CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(
          urlImage,
        ),
      ),
    );
  }
}
