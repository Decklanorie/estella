// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpResponseModel _$SignUpResponseModelFromJson(Map<String, dynamic> json) =>
    SignUpResponseModel(
      message: json['message'] as String?,
      userExist: json['userExist'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      success: json['success'] as bool?,
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SignUpResponseModelToJson(
        SignUpResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'userExist': instance.userExist,
      'message': instance.message,
      'statusCode': instance.statusCode,
      'user': instance.user,
    };
