import 'package:json_annotation/json_annotation.dart';
import 'package:estella/shared/data/models/user_model.dart';
part 'sign_up_response_model.g.dart';

@JsonSerializable()
class SignUpResponseModel{
  bool? success;
  bool? userExist;
  String? message;
  int? statusCode;
  UserModel? user;

  SignUpResponseModel({
    this.message,
    this.userExist,
    this.statusCode,
    this.success,
    this.user,
  });

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) => _$SignUpResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpResponseModelToJson(this);

}