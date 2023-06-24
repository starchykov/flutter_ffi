import 'package:flutter_ffi/data/repositories/scan_repository.dart';
import 'package:flutter_ffi/domain/models/plate_model/article_model.dart';

class ScanService {
  ScanRepository _scanRepository = ScanRepository();

  List<ArticleModel> _plates = <ArticleModel>[];

  List<ArticleModel>  get plates => _plates;

  Future<void> savePlate({
    required String username,
    required String plateNumber,
    required String location,
    required String modifiedDate,
    required String recognizedImagePath,
  }) async {
    await _scanRepository.savePlate(
      username: username,
      plateNumber: plateNumber,
      location: location,
      modifiedDate: modifiedDate,
      recognizedImagePath: recognizedImagePath,
    );
    _plates =  await _scanRepository.getPlates();
  }

  Future<void> getPlates() async {
    _plates =  await _scanRepository.getPlates();
  }

  Future<void> deletePlates() async {
    await _scanRepository.deletePlates();
    _plates = [];
  }

}