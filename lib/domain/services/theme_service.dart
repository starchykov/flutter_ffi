
import 'package:flutter_ffi/data/repositories/theme_repository.dart';

class ThemeService {
  final ThemeRepository _themeRepository = ThemeRepository();
  late String _themeMode;

  bool get isDarkMode => _themeMode == 'dark';

  Stream<String> get themeStream => _themeRepository.themeStream;

  Future<void> getThemeMode() async {
    _themeMode = await _themeRepository.getThemeMode();
  }

  Future<void> changeThemeMode() async {
    await getThemeMode();
    isDarkMode ? await setLightMode() : await setDarkMode();
  }

  Future<void> setDarkMode() async {
    await _themeRepository.setThemeMode(mode: 'dark');
    await getThemeMode();
  }

  Future<void> setLightMode() async {
    await _themeRepository.setThemeMode(mode: 'light');
    await getThemeMode();
  }
}
