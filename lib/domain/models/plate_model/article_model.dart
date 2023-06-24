import 'package:json_annotation/json_annotation.dart';

part 'article_model.g.dart';

/// The class is used to represent an article data model that can be used in the [ArticlePage] screen.
@JsonSerializable(includeIfNull: false)
class ArticleModel {
  final int id;
  final String username;
  final String plateNumber;
  final String location;
  final String modifiedDate;
  final String recognizedImagePath;


  /// Constructor method that initializes all the properties of the article object.
  /// It takes in optional parameters for all properties and provides default values if none are provided.


  /// Factory method that creates an article object from a JSON map.
  /// This method uses the _$ArticleModelFromJson method generated by the json_serializable package.
  factory ArticleModel.fromJson(Map<String, dynamic> json) => _$ArticleModelFromJson(json);

  /// Method that converts the article object to a JSON map.
  /// This method uses the _$ArticleModelToJson method generated by the json_serializable package.
  Map<String, dynamic> toJson() => _$ArticleModelToJson(this);


  /// Factory method that creates an article object from a Map object.
  /// This method takes in a Map object and uses the key-value pairs to initialize the properties of the article object.


  const ArticleModel({
    required this.id,
    required this.username,
    required this.plateNumber,
    required this.location,
    required this.modifiedDate,
    required this.recognizedImagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'username': this.username,
      'plateNumber': this.plateNumber,
      'location': this.location,
      'modifiedDate': this.modifiedDate,
      'recognizedImagePath': this.recognizedImagePath,
    };
  }

  factory ArticleModel.fromMap(Map<String, dynamic> map) {
    return ArticleModel(
      id: map['ID'] as int,
      username: map['USERNAME'] as String,
      plateNumber: map['PLATENUMBER'] as String,
      location: map['LOCATION'] as String,
      modifiedDate: map['MODIFIEDDATE'] as String,
      recognizedImagePath: map['RECOGNIZEDIMAGEPATH'] as String,
    );
  }
}