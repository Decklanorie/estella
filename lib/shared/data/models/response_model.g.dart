// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseModel _$ResponseModelFromJson(Map<String, dynamic> json) =>
    ResponseModel(
      message: json['message'] as String?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$ResponseModelToJson(ResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'statusCode': instance.statusCode,
    };
