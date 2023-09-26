import '/src/models/models.dart';
import '../services/services.dart';

class SettingsRepository {
  final DatabaseService _databaseService;

  SettingsRepository(this._databaseService);

  Future<Settings> getSettings() async {
    final settingsResult = await _databaseService.getSettings();
    final Settings settings = Settings.fromMap(settingsResult);
    return settings;
  }

  Future<void> saveSettings({required Settings settings}) async {
    Map<String, dynamic> settingsMap = settings.toMap();

    await _databaseService.saveSettings(settingsMap: settingsMap);
  }
}
