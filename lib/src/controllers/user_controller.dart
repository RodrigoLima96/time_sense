import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
  List<int>? image;
  final dateFormat = DateFormat('yyyy-MM-dd');

  UserController(this._userRepository) {
    getUser();
  }

  getUser() async {
    userPageState = UserPageState.loading;
    user = await _userRepository.getUser();
    await getUserStatisticsByDate();
    totalFocusTime = Helper.convertTaskTime(totalSeconds: user.totalFocusTime);
    userPageState = UserPageState.loaded;
    notifyListeners();
  }

  updateImage() async {
    final ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      user.image = await file.readAsBytes();
      await _userRepository.updateUser(user: user);
      notifyListeners();
    }
  }

  showOrHideTextFormField() {
    showTextFormField = !showTextFormField;
    notifyListeners();
  }

  updateUsername({required String name}) async {
    if (name != "") {
      user.name = name.trimRight();
      await _userRepository.updateUser(user: user);
    }
    showOrHideTextFormField();
  }

  getUserStatisticsByDate() async {
    const String initDate = '2023-10-31';
    const String endDate = '2023-11-01';

    final statistics = await _userRepository.getStatisticsByDate(
        initDate: initDate, endDate: endDate);

    totalFocusTimeByDate =
        Helper.convertTaskTime(totalSeconds: statistics['totalFocusTime']);
  }
}
