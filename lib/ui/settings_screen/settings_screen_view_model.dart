import 'package:flutter/material.dart';
import 'package:flutter_ffi/domain/services/theme_service.dart';
import 'package:flutter_ffi/ui/settings_screen/settings_screen_state.dart';

class SettingsScreenViewModel extends ChangeNotifier {
  final BuildContext context;
  final ThemeService _themeService = ThemeService();

  SettingsScreenState _state = SettingsScreenState();

  SettingsScreenState get state => _state;

  SettingsScreenViewModel({required this.context}) {
    initialize();
  }

  void initialize() async {
    await _themeService.getThemeMode();
    _state = _state.copyWith(isDarkMode: _themeService.isDarkMode);
    notifyListeners();
  }

  Future<void> onChangeTheme() async {
    await _themeService.changeThemeMode();
    _state = _state.copyWith(isDarkMode: _themeService.isDarkMode);
    notifyListeners();
  }
}