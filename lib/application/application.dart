import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ffi/app_navigation/app_navigation.dart';
import 'package:flutter_ffi/application/application_view_model.dart';

class LPRApplication extends StatelessWidget {
  const LPRApplication({Key? key}) : super(key: key);

  static Widget render() {
    return ChangeNotifierProvider<ApplicationViewModel>(
      create: (context) => ApplicationViewModel(),
      child: const LPRApplication(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ApplicationViewModel viewModel = context.read<ApplicationViewModel>();
    final CupertinoThemeData theme = context.select((ApplicationViewModel viewModel) => viewModel.appTheme);
    return CupertinoApp(
      navigatorKey: viewModel.appNavigationKey,
      debugShowCheckedModeBanner: false,
      routes: viewModel.appNavigationRoutes,
      initialRoute: AppNavigationRoutes.initializationWidget,
      title: 'License plate scanner',
      theme: theme,
    );
  }
}
