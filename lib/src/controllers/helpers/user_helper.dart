import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';

class UserHelper {
  static List<String> getStatisticsDates({required List<DateTime?>? dates}) {
    final dateFormat = DateFormat('yyyy-MM-dd');

    String initDate = '';
    String endDate = '';

    if (dates != null) {
      if (dates.length > 1) {
        initDate = dateFormat.format(dates[0]!);
        endDate = dateFormat.format(dates[1]!);
      } else {
        initDate = dateFormat.format(dates[0]!);
        endDate = dateFormat.format(dates[0]!);
      }
    } else {
      initDate = dateFormat.format(DateTime.now());
      endDate = dateFormat.format(DateTime.now());
    }

    return [initDate, endDate];
  }

  static String getCalendarButtonText(List<String> dates) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    if (dates.isEmpty || dates.length != 2) {
      return '';
    }

    final String currentDate = dateFormat.format(DateTime.now());

    if (dates[0] == dates[1] && dates[0] == currentDate) {
      return 'hoje';
    } else {
      if (dates[0] != dates[1]) {
        return '${convertDate(dates[0])}  -  ${convertDate(dates[1])}';
      }
      return convertDate(dates[0]).toString();
    }
  }

  static reduceImageSize({required File imageFile}) async {
    var reducedImage = await FlutterImageCompress.compressWithFile(
      imageFile.absolute.path,
      quality: 50,
    );
    return reducedImage;
  }

  static String convertDate(String date) {
    return DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
  }
}
