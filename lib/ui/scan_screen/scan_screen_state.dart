import 'package:flutter/cupertino.dart';
import 'package:flutter_ffi/domain/models/plate_model/article_model.dart';

@immutable
class ScanScreenState {
  final String recognizedImagePath;
  final String licensePlateNumber;
  final String tempDirectory;
  final List<ArticleModel> plates;
  final bool isProcessed;
  final bool isWorking;

  ScanScreenState({
    this.recognizedImagePath = '',
    this.licensePlateNumber = '',
    this.tempDirectory = '',
    this.plates = const [],
    this.isProcessed = false,
    this.isWorking = false,
  });

  ScanScreenState copyWith({
    String? recognizedImagePath,
    String? licensePlateNumber,
    String? tempDirectory,
    List<ArticleModel>? plates,
    bool? isProcessed,
    bool? isWorking,
  }) {
    return ScanScreenState(
      recognizedImagePath: recognizedImagePath ?? this.recognizedImagePath,
      licensePlateNumber: licensePlateNumber ?? this.licensePlateNumber,
      tempDirectory: tempDirectory ?? this.tempDirectory,
      plates: plates ?? this.plates,
      isProcessed: isProcessed ?? this.isProcessed,
      isWorking: isWorking ?? this.isWorking,
    );
  }
}
