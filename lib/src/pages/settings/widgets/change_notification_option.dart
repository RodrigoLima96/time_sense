import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:time_sense/src/shared/utils/utils.dart';

import '../../../controllers/controllers.dart';

class ChangeNotificationOption extends StatelessWidget {
  const ChangeNotificationOption({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: TextButton(
        child: Text(
          settingsController.notificationsAllowed
              ? 'Desabilitar Notificações'
              : 'Habilitar Notificações',
          style: textBold.copyWith(color: primaryColor),
        ),
        onPressed: () {
          settingsController.changeNotificationsPermission = true;
          settingsController.chageNotificationPermission();
        },
      ),
    ).animate().fade().slide(duration: 200.ms);
  }
}
