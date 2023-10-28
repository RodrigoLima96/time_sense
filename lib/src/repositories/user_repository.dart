import 'package:time_sense/src/models/models.dart';

import '../services/services.dart';

class UserRepository {
  final DatabaseService _databaseService;
  const UserRepository(this._databaseService);

  Future<User> getUser() async {
    final userResult = await _databaseService.getUser();
    User user = User.fromMap(userResult);
    return user;
  }

  Future<void> updateUser({required User user}) async {
    await _databaseService.updateUser(user: user.toMap());
  }
}
