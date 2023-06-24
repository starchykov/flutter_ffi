import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_ffi/app_navigation/app_navigation.dart';
import 'package:flutter_ffi/application/application_page_state.dart';
import 'package:flutter_ffi/domain/services/theme_service.dart';
import 'package:flutter_ffi/theme/app_theme.dart';


class ApplicationViewModel extends ChangeNotifier {
  final ThemeService _themeService = ThemeService();
  final AppTheme _appTheme = AppTheme();
  final AppNavigation _appNavigation = AppNavigation();
  late StreamSubscription _themeSubscription;

  ApplicationPageState _state = const ApplicationPageState(isDarkTheme: false, isOfflineMode: false);

  ApplicationPageState get state => _state;

  GlobalKey<NavigatorState> get appNavigationKey => _appNavigation.navigatorKey;

  Map<String, Widget Function(BuildContext)> get appNavigationRoutes => _appNavigation.routes;

  CupertinoThemeData get appTheme => _appTheme.getTheme(isDarkTheme: _state.isDarkTheme);

  ApplicationViewModel() {
    _initialize();
  }

  void _initialize() async {
    _themeSubscription = _themeService.themeStream.listen((_) => setTheme());
    await setTheme();
  }

  Future<void> setTheme() async {
    await _themeService.getThemeMode();
    _state = _state.copyWith(isDarkTheme: _themeService.isDarkMode);
    notifyListeners();
  }

  @override
  void dispose() {
    _themeSubscription.cancel();
    super.dispose();
  }
}
