
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ffi/app_navigation/app_navigation.dart';
import 'package:flutter_ffi/domain/clients/database/database_client.dart';
import 'package:path_provider/path_provider.dart';

class InitializationPageViewModel {
  final BuildContext context;

  InitializationPageViewModel({required this.context}) {
    initialize();
  }

  void initialize() async {
    log('Application started (${DateTime.now()})', name: 'AppBase Mobile Application');
    await DatabaseClient.database.open();
    await saveClassifications();
    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).pushNamedAndRemoveUntil(AppNavigationRoutes.homeWidget, (route) => false);
  }

  Future<void> saveClassifications() async {
    Directory appDocDir = await getTemporaryDirectory();

    ByteData classifications = await rootBundle.load('assets/sources/classifications.xml');
    File classificationsFile = File('${appDocDir.path}/classifications.xml');
    classificationsFile.writeAsBytesSync(classifications.buffer.asUint8List());

    ByteData images = await rootBundle.load('assets/sources/images.xml');
    File imagesFile = File('${appDocDir.path}/images.xml');
    imagesFile.writeAsBytesSync(images.buffer.asUint8List());
  }

}
