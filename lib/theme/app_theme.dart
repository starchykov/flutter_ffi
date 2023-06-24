import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const CupertinoThemeData lightTheme = CupertinoThemeData(
    primaryColor: Colors.blue,
    brightness: Brightness.light,
    barBackgroundColor: CupertinoColors.systemBackground,
    scaffoldBackgroundColor: CupertinoColors.systemBackground,
    textTheme: const CupertinoTextThemeData(
      textStyle: TextStyle(fontSize: 16, color: CupertinoColors.label),
      tabLabelTextStyle: TextStyle(fontSize: 12, color: CupertinoColors.label),
    ),
  );

  static final CupertinoThemeData darkTheme = CupertinoThemeData(
    primaryColor: Colors.blue,
    brightness: Brightness.dark,
    // barBackgroundColor: CupertinoColors.secondarySystemBackground.darkColor,
    scaffoldBackgroundColor: CupertinoColors.systemBackground.darkColor,
    textTheme: const CupertinoTextThemeData(
      textStyle: TextStyle(fontSize: 16, color: CupertinoColors.white),
      tabLabelTextStyle: TextStyle(fontSize: 12, color: CupertinoColors.inactiveGray),
    ),
  );

  CupertinoThemeData getTheme({required bool isDarkTheme}) => isDarkTheme ? darkTheme : lightTheme;
}
