import 'package:flutter/material.dart';
import 'package:flutter_ffi/app_navigation/app_navigation.dart';

class HomeScreenViewModel extends ChangeNotifier {
  final BuildContext context;
  final AppNavigation _appNavigation = AppNavigation();

  HomeScreenViewModel({required this.context}) {
    initialize();
  }

  void initialize() async {
    //   ToDo smth
  }

  Widget renderScreen({required int screenIndex}) {
    return _appNavigation.bottomNavigationScreens[screenIndex];
  }
}
