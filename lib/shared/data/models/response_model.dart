import 'package:json_annotation/json_annotation.dart';
part 'response_model.g.dart';

@JsonSerializable()
class ResponseModel{
  bool? success;
  String? message;
  int? statusCode;

  ResponseModel({
    this.message,
    this.statusCode,
    this.success,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) => _$ResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseModelToJson(this);

}