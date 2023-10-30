import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/controllers.dart';
import '../../../shared/utils/utils.dart';

class UsernameWidget extends StatelessWidget {
  const UsernameWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController textFieldController = TextEditingController();

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final userController = context.watch<UserController>();

    textFieldController.text = userController.user.name!;
    final bool smallName = userController.user.name!.length < 3;

    return Container(
      margin: const EdgeInsets.only(top: 14),
      child: userController.showTextFormField
          ? Center(
              child: Form(
                key: formKey,
                child: TextFormField(
                  autofocus: userController.showTextFormField,
                  controller: textFieldController,
                  onTapOutside: (event) {
                    if (!userController.showTextFormField) {
                      FocusScope.of(context).unfocus();
                    }
                    userController.updateUsername(
                        name: textFieldController.text);
                  },
                  onEditingComplete: () {
                    userController.updateUsername(
                        name: textFieldController.text);
                  },
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: whiteColor,
                      fontWeight: FontWeight.normal,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  style: textBold,
                ),
              ),
            )
          : InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 5, left: smallName ? 10 : 0),
                height: 30,
                width: smallName ? 30 : null,
                child: Text(userController.user.name!, style: textBold),
              ),
              onTap: () {
                userController.showOrHideTextFormField();
              },
            ),
    );
  }
}
