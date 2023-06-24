import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_ffi/domain/models/plate_model/article_model.dart';
import 'package:flutter_ffi/ui/scan_screen/scan_screen_state.dart';
import 'package:flutter_ffi/ui/scan_screen/scan_screen_view_model.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({Key? key}) : super(key: key);

  static Widget render() {
    return ChangeNotifierProvider(
      create: (context) => ScanScreenViewModel(context: context),
      child: const ScanScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScanScreenViewModel viewModel = context.read<ScanScreenViewModel>();
    ScanScreenState state = context.select((ScanScreenViewModel viewMode) => viewMode.state);
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text('License plate scanner'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(CupertinoIcons.camera_viewfinder, color: CupertinoColors.activeBlue),
              onPressed: () => viewModel.takeImageAndProcess(imageSource: ImageSource.camera),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(CupertinoIcons.add, color: CupertinoColors.activeBlue),
              onPressed: () => viewModel.takeImageAndProcess(imageSource: ImageSource.gallery),
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            _DashboardSlider(
              title: 'Captured cars',
              color: 'F',
              articles: state.plates,
            ),
            CupertinoListSection.insetGrouped(
              header: Row(
                children: [
                  Text('Recognized plates'),
                  Spacer(),
                  CupertinoButton(
                    child: Icon(CupertinoIcons.delete, color: CupertinoColors.destructiveRed),
                    onPressed: viewModel.deletePlates,
                  )
                ],
              ),
              children: [
                ...state.plates.map((e) {
                  return CupertinoListTile(
                    onTap: () async => await viewModel.loadDetailData(article: e),
                    leading: Icon(CupertinoIcons.camera_viewfinder),
                    title: Text('${e.plateNumber}'),
                    subtitle: Text('${e.location} ${e.modifiedDate}'),
                    additionalInfo: Text('${e.username}', style: CupertinoTheme.of(context).textTheme.tabLabelTextStyle),
                    trailing: CupertinoListTileChevron(),
                  );
                }).toList()
              ],
            )
          ],
        ),
      ),
    );
  }

}

class _DashboardSlider extends StatelessWidget {
  const _DashboardSlider({
    Key? key,
    required this.title,
    required this.color,
    required this.articles,
  }) : super(key: key);

  final String title;
  final String color;
  final List<ArticleModel> articles;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(
                  '${articles.length} items',
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .tabLabelTextStyle
                      .merge(const TextStyle(color: CupertinoColors.inactiveGray)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: [
                ...articles
                    .map((ArticleModel articleType) => _Article(article: articleType, title: title, color: color))
                    .toList(),
                if (articles.isEmpty) const _EmptyCategories(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Article extends StatelessWidget {
  const _Article({
    Key? key,
    required this.title,
    required this.color,
    required this.article,
  }) : super(key: key);

  final ArticleModel article;
  final String title;
  final String color;

  @override
  Widget build(BuildContext context) {
    ScanScreenViewModel viewModel = context.read<ScanScreenViewModel>();
    ScanScreenState state = context.select((ScanScreenViewModel viewMode) => viewMode.state);
    return CupertinoButton(
      padding: const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 12.0),
      onPressed: () async => await viewModel.showScannedImage(article: article),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Stack(
          children: [
            Image.file(
              File(article.recognizedImagePath),
              alignment: Alignment.center,
              width: (MediaQuery.of(context).size.width / 2) - 12 * 2.0,
              fit: BoxFit.cover,
            ),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [.15, .45],
                  colors: <Color>[
                    CupertinoColors.black.withOpacity(.3),
                    CupertinoColors.black.withOpacity(.5),
                  ],
                  tileMode: TileMode.mirror,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(CupertinoIcons.camera_viewfinder, color: CupertinoColors.activeBlue),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 12, top: 12.0, right: 18.0, bottom: 8.0),
                      width: (MediaQuery.of(context).size.width / 2) - 12 * 2.0,
                      decoration: const BoxDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.username,
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .tabLabelTextStyle
                                .merge(const TextStyle(color: CupertinoColors.white)),
                          ),
                          const Spacer(),
                          Text(
                            article.plateNumber,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.white),
                          ),
                          Text(
                            '${article.location} ${article.modifiedDate}',
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .tabLabelTextStyle
                                .merge(TextStyle(color: CupertinoColors.white.withOpacity(.6))),
                          ),
                          const Spacer(),
                          Text(
                            article.plateNumber,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12, color: CupertinoColors.white.withOpacity(.6)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// This widget is responsible for displaying empty plug when list of [CaseTypesModel] is empty.
class _EmptyCategories extends StatelessWidget {
  const _EmptyCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScanScreenViewModel viewModel = context.read<ScanScreenViewModel>();
    ScanScreenState state = context.select((ScanScreenViewModel viewMode) => viewMode.state);
    return CupertinoButton(
      padding: const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 12.0),
      onPressed: viewModel.getPlates,
      child: Stack(
        children: [
          Positioned(
            top: 8.0,
            right: 8.0,
            child: Row(
              children: [
                const Icon(CupertinoIcons.arrow_clockwise, size: 12.0),
                const SizedBox(width: 4.0),
                Text(
                  'Reload',
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .tabLabelTextStyle
                      .merge(const TextStyle(color: CupertinoColors.activeBlue)),
                ),
              ],
            ),
          ),
          Container(
            width: (MediaQuery.of(context).size.width / 2) - 12 * 2.0,
            decoration: const BoxDecoration(
              color: CupertinoColors.secondarySystemFill,
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                state.isWorking
                    ? const CupertinoActivityIndicator(radius: 12)
                    : const Icon(CupertinoIcons.tray, size: 32.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        state.isWorking ? 'Loading' :  'There are no recognized plates detected',
                        style: const TextStyle(fontSize: 12.0, color: CupertinoColors.inactiveGray),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
