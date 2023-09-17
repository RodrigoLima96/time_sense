import 'package:flutter/widgets.dart';

import '../../../shared/utils/utils.dart';
import '../../../shared/widgets/widgets.dart';

class SettingsOptionsButtons extends StatelessWidget {
  const SettingsOptionsButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 50),
      
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PrimaryButton(
            text: 'Cancelar',
            press: () {},
            color: secondaryColor,
            height: 12,
            width: 40,
          ),

          const SizedBox(width: 70),

          PrimaryButton(
            text: 'Salvar',
            press: () {},
            color: primaryColor,
            height: 12,
            width: 45,
          ),
        ],
      ),
    );
  }
}
