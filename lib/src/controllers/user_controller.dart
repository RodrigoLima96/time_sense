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
  List<int>? image;

  UserController(this._userRepository) {
    getUser();
  }

  getUser() async {
    user = await _userRepository.getUser();
    totalFocusTime = Helper.convertTaskTime(totalSeconds: user.totalFocusTime);
    userPageState = UserPageState.loaded;
    notifyListeners();
  }

  updateUser({int? focusTime, int? tasksDone}) async {
    user.totalFocusTime += focusTime ?? 0;
    user.totalTasksDone += tasksDone ?? 0;

    user.totalTasksDone = user.totalTasksDone < 0 ? 0 : user.totalTasksDone;

    totalFocusTime = Helper.convertTaskTime(totalSeconds: user.totalFocusTime);
    await _userRepository.updateUser(user: user);
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
}
