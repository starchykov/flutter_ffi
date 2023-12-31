import 'package:flutter/cupertino.dart';
import 'package:flutter_ffi/ui/home_screen/home_screen_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static Widget render() {
    return ChangeNotifierProvider<HomeScreenViewModel>(
      create: (context) => HomeScreenViewModel(context: context),
      child: const HomeScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final HomeScreenViewModel viewModel = context.read<HomeScreenViewModel>();
    return CupertinoTabScaffold(
      tabBuilder: (builder, int index) => viewModel.renderScreen(screenIndex: index),
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.layers_alt),
            activeIcon: Icon(CupertinoIcons.layers_alt_fill),
            label: 'Scan plates',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
          )
        ],
      ),
    );
  }
}
