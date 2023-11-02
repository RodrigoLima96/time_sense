import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/controllers.dart';
import '../../../shared/utils/utils.dart';
import '../../../shared/widgets/widgets.dart';
import 'widgets.dart';

class StatisticsByDateWidget extends StatefulWidget {
  const StatisticsByDateWidget({super.key});

  @override
  State<StatisticsByDateWidget> createState() => _StatisticsByDateWidgetState();
}

class _StatisticsByDateWidgetState extends State<StatisticsByDateWidget> {
  @override
  Widget build(BuildContext context) {
    final userController = context.watch<UserController>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PrimaryButton(
                text: userController.calendarButtonText,
                press: () async {
                  final dates = await showCalendarDatePicker2Dialog(
                    context: context,
                    config: CalendarDatePicker2WithActionButtonsConfig(
                      calendarType: CalendarDatePicker2Type.range,
                      dayTextStyle: textRegular,
                      weekdayLabelTextStyle: textBold,
                      yearTextStyle: textBold,
                      controlsTextStyle: textBold,
                      selectedDayTextStyle: textBold,
                      centerAlignModePicker: true,
                      cancelButtonTextStyle: textBold,
                      okButtonTextStyle: textBold,
                      selectedRangeDayTextStyle: textBold.copyWith(
                        color: blackColor,
                      ),
                      selectedDayHighlightColor: const Color(0xFF5D32C0),
                    ),
                    dialogSize: const Size(325, 400),
                    borderRadius: BorderRadius.circular(15),
                    value: userController.dialogCalendarPickerValue,
                    dialogBackgroundColor: primaryColor,
                  );
                  if (dates != null) {
                    await userController.getUserStatisticsByDate(dates: dates);
                    setState(() {});
                  }
                },
                color: secondaryColor,
                height: 6,
                backIcon: 'assets/icons/arrow-back-icon.svg',
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 50),
          child: userController.totalFocusTimeByDate!['totalSeconds']! > 0
              ? TotalFocusingTimeWidget(
                  hours: userController.totalFocusTimeByDate!['hour']!,
                  minutes: userController.totalFocusTimeByDate!['minutes']!,
                  totalSeconds:
                      userController.totalFocusTimeByDate!['totalSeconds']!,
                  seconds: userController.totalFocusTimeByDate!['seconds']!,
                  text: 'Foco',
                  taskPending: true,
                )
              : const Text('Sem tempo de foco nesse período', style: textBold),
        ),
        Container(
          margin: const EdgeInsets.only(top: 50),
          child: const TasksCompletedWidget(totalTasks: 3, text: 'Tarefas'),
        ),
      ],
    );
  }
}
