import 'package:time_sense/src/models/models.dart';

import '../services/services.dart';

class UserRepository {
  final DatabaseService _databaseService;
  const UserRepository(this._databaseService);

  Future<User> getUser() async {
    final userResult = await _databaseService.getUser();
    final User user = User.fromMap(userResult);
    return user;
  }

  Future<void> updateUser({required User user}) async {
    await _databaseService.updateUser(user: user.toMap());
  }

  Future<void> updateUserStatistics({int? focusTime, int? tasksDone}) async {
    final userResult = await _databaseService.getUser();
    final User user = User.fromMap(userResult);

    user.totalFocusTime += focusTime ?? 0;
    user.totalTasksDone += tasksDone ?? 0;

    user.totalTasksDone = user.totalTasksDone < 0 ? 0 : user.totalTasksDone;

    await _databaseService.updateUser(user: user.toMap());
  }

  Future<int> getStatisticsByDate(
      {required String initDate, required String? endDate}) async {
    final statistics = await _databaseService.getStatistics(
        initDate: initDate, endDate: endDate);

    int totalFocusTime = 0;
    for (var map in statistics) {
      totalFocusTime += map['totalFocusingTime'] as int;
    }

    return totalFocusTime;
  }
}
