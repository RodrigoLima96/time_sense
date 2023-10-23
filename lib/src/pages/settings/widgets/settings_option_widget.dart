// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../controllers/controllers.dart';
import '../../../shared/utils/utils.dart';
import 'widgets.dart';

class SettingsOptionWidget extends StatefulWidget {
  final String text;
  final String setting;
  final double margin;
  final String settingType;
  final bool? notification;
  double? width;

  SettingsOptionWidget({
    super.key,
    required this.text,
    required this.setting,
    this.margin = 40,
    required this.settingType,
    this.notification,
    this.width,
  });

  @override
  State<SettingsOptionWidget> createState() => _SettingsOptionWidgetState();
}

class _SettingsOptionWidgetState extends State<SettingsOptionWidget>
    with WidgetsBindingObserver {
  late SettingsController settingsController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed &&
        settingsController.changeNotificationsPermission) {
      await settingsController.checkNotificationPermission(isInit: false);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    settingsController = context.watch<SettingsController>();

    final bool showDetails =
        settingsController.showSettinsDetails(settingType: widget.settingType);

    return Column(
      children: [
        Container(
          height: 40,
          width: widget.width ?? size.width * 0.85,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: secondaryColor,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              margin: const EdgeInsets.only(left: 30, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.text, style: textBold),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 15),
                        child: Text(widget.setting, style: textBold),
                      ),
                      Transform.rotate(
                        angle: showDetails ? 4.68 : 3.2,
                        child: SizedBox(
                          width: 50,
                          child: SvgPicture.asset(
                            'assets/icons/arrow-back-icon.svg',
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            onTap: () {
              settingsController.selectSettingOption(
                  settingType: widget.settingType);
            },
          ),
        ),
        showDetails
            ? widget.notification == null
                ? ChangeSettingValueWidget(
                    settingType: widget.settingType,
                  )
                : const ChangeNotificationOption()
            : const SizedBox(),
        SizedBox(height: showDetails ? 0 : widget.margin),
      ],
    );
  }
}
