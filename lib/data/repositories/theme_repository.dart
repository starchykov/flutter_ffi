import 'dart:async';
import 'dart:ui';

import 'package:flutter/scheduler.dart';
import 'package:flutter_ffi/domain/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeRepository {
  ThemeRepository._internal();

  static final ThemeRepository _instance = ThemeRepository._internal();

  factory ThemeRepository() {
    return _instance;
  }

  StreamController<String> _themeStreamController = StreamController<String>.broadcast();

  Stream<String> get themeStream => _themeStreamController.stream.asBroadcastStream();

  Future<String> getThemeMode() async {
    Brightness brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    Object? themeMode = (await SharedPreferences.getInstance()).get('color_theme');
    return themeMode?.toString() ?? brightness.name;
  }

  Future<void> setThemeMode({required String mode}) async {
    (await SharedPreferences.getInstance()).setString('color_theme', mode);
    Constants.darkMode = mode == 'dark';
    _themeStreamController.add(mode);
  }
}
