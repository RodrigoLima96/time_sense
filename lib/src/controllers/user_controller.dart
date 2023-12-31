import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/models.dart';
import '../repositories/repositories.dart';
import 'helpers/helpers.dart';

enum UserPageState { loading, loaded }

class UserController extends ChangeNotifier {
  final UserRepository _userRepository;
  late User user;
  bool showTextFormField = false;
  UserPageState userPageState = UserPageState.loading;
  Map<String, int>? totalFocusTime;
  Map<String, int>? totalFocusTimeByDate;
  int totalTasksDoneByDate = 0;
  String calendarButtonText = 'Today';
  List<DateTime?> dialogCalendarPickerValue = [];
  List<int>? image;

  UserController(this._userRepository) {
    getUser();
  }

  getUser() async {
    userPageState = UserPageState.loading;
    user = await _userRepository.getUser();
    image ??= user.image;
    await getUserStatisticsByDate(dates: null, initWidget: true);
    totalFocusTime = Helper.convertTaskTime(totalSeconds: user.totalFocusTime);
    userPageState = UserPageState.loaded;
    notifyListeners();
  }

  Future<void> updateImage() async {
    final ImagePicker imagePicker = ImagePicker();

    final XFile? file =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      final resizedImageBytes = await UserHelper.reduceImageSize(
        imageFile: File(file.path),
      );
      user.image = resizedImageBytes;
      image = user.image;

      await _userRepository.updateUser(user: user);
      notifyListeners();
    }
  }

  showOrHideTextFormField() {
    showTextFormField = !showTextFormField;
  }

  updateUsername({required String name}) async {
    if (name != "") {
      user.name = name.trimRight();
      await _userRepository.updateUser(user: user);
    }
    showOrHideTextFormField();
  }

  getUserStatisticsByDate(
      {required List<DateTime?>? dates, bool? initWidget}) async {
    List<String> listDates = UserHelper.getStatisticsDates(dates: dates);
    calendarButtonText = UserHelper.getCalendarButtonText(listDates);

    dialogCalendarPickerValue = initWidget != null
        ? [DateTime.now().add(const Duration(days: -1))]
        : [
            dates![0],
            dates.length > 1 ? dates[1] : null,
          ];

    final totalFocusTime = await _userRepository.getStatisticsByDate(
        initDate: listDates[0], endDate: listDates[1]);

    totalTasksDoneByDate = await _userRepository.getTotalTasksByDate(
        initDate: listDates[0], endDate: listDates[1]);

    totalFocusTimeByDate = Helper.convertTaskTime(totalSeconds: totalFocusTime);
  }
}
