import 'package:json_annotation/json_annotation.dart';
part 'wp_response_model.g.dart';

@JsonSerializable()
class WPResponseModel{
  bool? success;
  String? message;
  int? statusCode;
  List? posts;
  List? categories;
  Map<String,dynamic>? post;
  Map<String,dynamic>? category;

  WPResponseModel({
    this.message,
    this.statusCode,
    this.success,
    this.posts,
    this.categories,
    this.post,
    this.category,
  });

  factory WPResponseModel.fromJson(Map<String, dynamic> json) => _$WPResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$WPResponseModelToJson(this);

}