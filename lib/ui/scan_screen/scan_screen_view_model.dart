import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter_ffi/native_opencv.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter_ffi/domain/models/plate_model/article_model.dart';
import 'package:flutter_ffi/domain/services/scan_service.dart';
// import 'package:flutter_ffi/native_opencv.dart';
import 'package:flutter_ffi/ui/scan_screen/scan_screen_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ScanScreenViewModel extends ChangeNotifier {
  final BuildContext context;
  final ScanService _scanService = ScanService();
  final ImagePicker _picker = ImagePicker();

  ScanScreenState _state = ScanScreenState();

  ScanScreenState get state => _state;

  ScanScreenViewModel({required this.context}) {
    initialize();
  }

  initialize() async {
    Directory tempDirectory = await getTemporaryDirectory();
    _state = _state.copyWith(tempDirectory: tempDirectory.path);
    await getPlates();
  }

  Future<String> pickAnImage({required ImageSource imageSource}) async {
    final XFile? imagePath = await _picker.pickImage(source: imageSource, imageQuality: 100);
    return imagePath?.path ?? '';
  }

  void getLicencePlateNumber() {
    final String licensePlateNumber = opencvVersion();
    _state = _state.copyWith(licensePlateNumber: licensePlateNumber);
    notifyListeners();
  }

  Future<void> takeImageAndProcess({required ImageSource imageSource}) async {
    final String imagePath = await pickAnImage(imageSource: imageSource);
    final String fileName = '${imagePath.split('/').last}';

    if (imagePath.isEmpty) return;

    _state = _state.copyWith(isWorking: true);
    notifyListeners();

    /// Creating a port for communication with isolate and arguments for entry point.
    final port = ReceivePort();
    final args = ProcessImageArguments(imagePath, '${_state.tempDirectory}/$fileName', _state.tempDirectory);

    /// Spawning an isolate.
    Isolate.spawn<ProcessImageArguments>(processImage, args, onError: port.sendPort, onExit: port.sendPort);

    /// Making a variable to store a subscription in.
    late StreamSubscription sub;

    /// Listening for messages on port.
    sub = port.listen((_) async {
      await sub.cancel();

      _state = _state.copyWith(isWorking: false, isProcessed: true, recognizedImagePath: '${_state.tempDirectory}/$fileName');
      print('${_state.tempDirectory}/$fileName');

      getLicencePlateNumber();
      await savePlates();
    });
  }

  Future<void> getPlates() async {
    await _scanService.getPlates();
    _state = _state.copyWith(plates: _scanService.plates);
    notifyListeners();
  }

  Future<void> savePlates() async {
    await _scanService.savePlate(
      username: 'Ivan Starchykov',
      plateNumber: _state.licensePlateNumber,
      location: 'Ukraine',
      modifiedDate: '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}',
      recognizedImagePath: _state.recognizedImagePath,
    );
    _state = _state.copyWith(plates: _scanService.plates);
    notifyListeners();
  }

  Future<void> deletePlates() async {
    await _scanService.deletePlates();
    _state = _state.copyWith(plates: _scanService.plates);
    notifyListeners();
  }

  Future<void> showScannedImage({required ArticleModel article}) async {
    await showCupertinoModalPopup(
      context: context,
      barrierColor: CupertinoColors.separator,
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2, tileMode: TileMode.mirror),
      builder: (context) => Container(
        clipBehavior: Clip.hardEdge,
        height: MediaQuery.of(context).size.height * .45,
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: CupertinoTheme.of(context).scaffoldBackgroundColor.withOpacity(.8),
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            CupertinoListTile(
              padding: EdgeInsets.zero,
              leading: Icon(CupertinoIcons.camera_viewfinder),
              title: Text('${article.plateNumber}'),
              subtitle: Text('${article.location} ${article.modifiedDate}'),
              additionalInfo: Text('${article.username}', style: CupertinoTheme.of(context).textTheme.tabLabelTextStyle),
              trailing: CupertinoButton(
                minSize: 0,
                padding: EdgeInsets.zero,
                child: Icon(CupertinoIcons.clear_circled),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            SizedBox(height: 12),
            Image.file(
              File(article.recognizedImagePath),
              alignment: Alignment.center,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadDetailData({required ArticleModel article}) async {
    final String url = 'https://checkcar.com.ua/api/car-details/plate/';
    final String etag = 'W/"2483-3ujUn7Wv4MHB2ivTzsNlyZEHOOY"';
    final String plateNumber = article.plateNumber; // Replace with desired plate number
    print(Uri.parse('$url$plateNumber'));

    final response = await http.get(
      Uri.parse('$url$plateNumber'),
      headers: {
        'if-none-match': etag,
      },
    );

    var data = [];
    if (response.body.isNotEmpty) data = jsonDecode(response.body);

    await showCupertinoModalPopup(
      context: context,
      barrierColor: CupertinoColors.separator,
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2, tileMode: TileMode.mirror),
      builder: (context) => Container(
        clipBehavior: Clip.hardEdge,
        height: MediaQuery.of(context).size.height * .45,
        decoration: BoxDecoration(
          color: CupertinoTheme.of(context).scaffoldBackgroundColor.withOpacity(.8),
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            if (data.length == 0)
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * .45,
                child: Text(
                  'Request failed, \nplease check requested plate number',
                  textAlign: TextAlign.center,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .navLargeTitleTextStyle
                      .merge(TextStyle(color: CupertinoColors.inactiveGray)),
                ),
              ),
            ...data.map((response) {
              return CupertinoListSection.insetGrouped(
                header: Text('${response['brand']} ${response['year']}'),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CupertinoListTile(
                        leading: Icon(CupertinoIcons.car_detailed),
                        title: Text('${response['body']} ${response['color']} ${response['kind']}'),
                        subtitle: Text(
                          '${article.plateNumber} - ${response['openData'][0]['departament']}',
                          style: TextStyle(color: CupertinoColors.activeBlue),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                        child: RichText(
                          textAlign: TextAlign.left,
                          softWrap: true,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Дата останньої операції МВС: ${DateTime.parse('${response['openData'][0]['dateReg']}').toUtc()}',
                                style: CupertinoTheme.of(context).textTheme.tabLabelTextStyle,
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                        child: RichText(
                          textAlign: TextAlign.left,
                          softWrap: true,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Місце останньої операції МВС: ${response['openData'][0]['departament']}',
                                style: CupertinoTheme.of(context).textTheme.tabLabelTextStyle,
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                        child: RichText(
                          textAlign: TextAlign.left,
                          softWrap: true,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                'Тип останньої операції МВС: ${response['openData'][0]['operationName']}',
                                style: CupertinoTheme.of(context).textTheme.tabLabelTextStyle,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              );
            }).toList()
          ],
        ),
      ),
    );
  }
}
