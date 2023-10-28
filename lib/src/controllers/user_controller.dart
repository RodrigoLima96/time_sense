import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/models.dart';
import '../repositories/repositories.dart';
import 'helpers/helpers.dart';

enum UserPageState { loading, loaded }

class UserController extends ChangeNotifier {
  final UserRepository _userRepository;
  late User user;
  UserPageState userPageState = UserPageState.loading;
  Map<String, int>? totalFocusTime;
  List<int>? image;

  UserController(this._userRepository) {
    getUser();
  }

  getUser() async {
    user = await _userRepository.getUser();

    totalFocusTime = Helper.convertTaskTime(totalSeconds: user.totalFocusTime!);
    userPageState = UserPageState.loaded;
    await updateUser();
    notifyListeners();
  }

  updateUser() async {
    image = await pickImage();

    user = User(
      name: 'Rodrigo Lima',
      image: image,
      totalFocusTime: 139234,
      totalTasksDone: 72,
    );

    totalFocusTime = Helper.convertTaskTime(totalSeconds: user.totalFocusTime!);
    await _userRepository.updateUser(user: user);
  }

  pickImage() async {
    final ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      return await file.readAsBytes();
    }
  }
}
