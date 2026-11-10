// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wp_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WPResponseModel _$WPResponseModelFromJson(Map<String, dynamic> json) =>
    WPResponseModel(
      message: json['message'] as String?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      success: json['success'] as bool?,
      posts: json['posts'] as List<dynamic>?,
      categories: json['categories'] as List<dynamic>?,
      post: json['post'] as Map<String, dynamic>?,
      category: json['category'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$WPResponseModelToJson(WPResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'statusCode': instance.statusCode,
      'posts': instance.posts,
      'categories': instance.categories,
      'post': instance.post,
      'category': instance.category,
    };
