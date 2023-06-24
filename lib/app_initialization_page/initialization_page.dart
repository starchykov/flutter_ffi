import 'package:flutter/cupertino.dart';
import 'package:flutter_ffi/app_initialization_page/initialization_page_view_model.dart';
import 'package:provider/provider.dart';

class InitializationPage extends StatelessWidget {
  const InitializationPage({Key? key}) : super(key: key);

  static Widget render() {
    return Provider<InitializationPageViewModel>(
      create: (context) => InitializationPageViewModel(context: context),
      lazy: false,
      child: const InitializationPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: CupertinoTheme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Spacer(),
          Spacer(),
          Icon(CupertinoIcons.camera_viewfinder, size: 100.0, color: CupertinoColors.activeBlue),
          const SizedBox(height: 16),
          Text(
            'Plate scanner',
            style: CupertinoTheme.of(context)
                .textTheme
                .navLargeTitleTextStyle
                .merge(TextStyle(color: CupertinoColors.inactiveGray)),
          ),
          const SizedBox(height: 16),
          const CupertinoActivityIndicator(),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/ecx_logo_white.jpeg'),
                    alignment: Alignment.bottomCenter,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '© I. Starchykov 2023',
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .tabLabelTextStyle
                        .merge(TextStyle(color: CupertinoColors.inactiveGray)),
                  ),
                  Text(
                    'for V. N. Karazin Kharkiv National University',
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .tabLabelTextStyle
                        .merge(TextStyle(color: CupertinoColors.inactiveGray.withOpacity(.5))),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32.0),
        ],
      ),
    );
  }
}
