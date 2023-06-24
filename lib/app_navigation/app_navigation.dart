import 'package:flutter/widgets.dart';
import 'package:flutter_ffi/app_initialization_page/initialization_page.dart';
import 'package:flutter_ffi/ui/home_screen/home_screen.dart';
import 'package:flutter_ffi/ui/scan_screen/scan_screen.dart';
import 'package:flutter_ffi/ui/settings_screen/settings_screen.dart';


abstract class AppNavigationRoutes {
  static const initializationWidget = '/';
  static const scanScreen = '/scan_screen';
  static const homeWidget = '/home_screen';
}

class AppNavigation {
  AppNavigation._privateConstructor();

  static final AppNavigation _instance = AppNavigation._privateConstructor();

  factory AppNavigation() {
    return _instance;
  }

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  final Map<String, Widget Function(BuildContext)> routes = <String, Widget Function(BuildContext)>{
    AppNavigationRoutes.initializationWidget: (context) => InitializationPage.render(),
    AppNavigationRoutes.homeWidget: (context) => HomeScreen.render(),
    AppNavigationRoutes.scanScreen: (context) => ScanScreen.render(),
  };

  final List<Widget> bottomNavigationScreens = <Widget>[
    ScanScreen.render(),
    SettingsScreen.render(),
  ];
}
