import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../controllers/controllers.dart';
import '../../../shared/utils/utils.dart';
import '../../../shared/widgets/widgets.dart';

class SettingsOptionsButtons extends StatelessWidget {
  const SettingsOptionsButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();
    final pomodoroController = context.read<PomodoroController>();

    final bool enableButtons = settingsController.enableButtons;
    return Container(
      margin: const EdgeInsets.only(bottom: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PrimaryButton(
            text: 'Cancelar',
            press: () {
              settingsController.cancelChanges();
            },
            color: enableButtons ? primaryColor : secondaryColor,
            height: 12,
            width: 40,
          ),
          const SizedBox(width: 70),
          PrimaryButton(
            text: 'Salvar',
            press: () {
              settingsController.saveSettings();
              pomodoroController.updatePomodoroAfterSettingsChanges();
            },
            color: enableButtons ? primaryColor : secondaryColor,
            height: 12,
            width: 45,
          ),
        ],
      ),
    );
  }
}
