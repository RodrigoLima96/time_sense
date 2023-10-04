// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:time_sense/src/shared/utils/constants.dart';

Future<void> showDeleteConfirmationDialog({
  required BuildContext context,
  required Function onDelete,
  String? icon,
  required String text,
}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: ModalRoute.of(context)!.animation!,
          curve: const Interval(0.0, 1.0, curve: Curves.linear),
        )),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: primaryColor,
          title: icon != null
              ? SvgPicture.asset(icon, color: Colors.red.shade300)
              : Text(text, style: textRegular),
          content: icon == null
              ? RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(
                        text: '23',
                        style: textBold,
                      ),
                      TextSpan(text: ' minutos, ', style: textRegular),
                      TextSpan(
                        text: '13',
                        style: textBold,
                      ),
                      TextSpan(text: ' segundos', style: textRegular),
                    ],
                  ),
                )
              : Text(text, style: textRegular),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: const Text('Não', style: textBold),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Sim', style: textBold),
                  onPressed: () {
                    onDelete();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
