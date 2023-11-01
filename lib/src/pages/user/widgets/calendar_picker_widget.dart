import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:time_sense/src/shared/widgets/primary_button.dart';

import '../../../shared/utils/utils.dart';

class CalendarPickerWidget extends StatelessWidget {
  const CalendarPickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<DateTime?> dialogCalendarPickerValue = [
      DateTime(2023, 11, 02),
      DateTime(2023, 11, 05),
    ];

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PrimaryButton(
            text: 'hoje',
            press: () async {
              final values = await showCalendarDatePicker2Dialog(
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
                  selectedRangeDayTextStyle:
                      textBold.copyWith(color: blackColor),
                  selectedDayHighlightColor: const Color(0xFF5D32C0),
                ),
                dialogSize: const Size(325, 400),
                borderRadius: BorderRadius.circular(15),
                value: dialogCalendarPickerValue,
                dialogBackgroundColor: primaryColor,
              );
              // await userController.getUserStatisticsByDate(values);
              print(values);
            },
            color: secondaryColor,
            height: 6,
            backIcon: 'assets/icons/arrow-back-icon.svg',
          ),
        ],
      ),
    );
  }
}
