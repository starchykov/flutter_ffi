// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleModel _$ArticleModelFromJson(Map<String, dynamic> json) => ArticleModel(
      id: json['id'] as int,
      username: json['username'] as String,
      plateNumber: json['plateNumber'] as String,
      location: json['location'] as String,
      modifiedDate: json['modifiedDate'] as String,
      recognizedImagePath: json['recognizedImagePath'] as String,
    );

Map<String, dynamic> _$ArticleModelToJson(ArticleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'plateNumber': instance.plateNumber,
      'location': instance.location,
      'modifiedDate': instance.modifiedDate,
      'recognizedImagePath': instance.recognizedImagePath,
    };
