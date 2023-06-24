import 'package:flutter_ffi/data/data_providers/scan_data_provider.dart';
import 'package:flutter_ffi/domain/models/plate_model/article_model.dart';

class ScanRepository {
  ScanDataProvider _scanDataProvider = ScanDataProvider();

  Future<void> savePlate({
    required String username,
    required String plateNumber,
    required String location,
    required String modifiedDate,
    required String recognizedImagePath,
  }) async {
    await _scanDataProvider.savePlate(
      username: username,
      plateNumber: plateNumber,
      location: location,
      modifiedDate: modifiedDate,
      recognizedImagePath: recognizedImagePath,
    );
  }

  Future<List<ArticleModel>> getPlates() async {
    return (await _scanDataProvider.getPlates()).map((article) => ArticleModel.fromMap(article)).toList();
  }

  Future<void> deletePlates() async {
    await _scanDataProvider.deletePlates();
  }
}
