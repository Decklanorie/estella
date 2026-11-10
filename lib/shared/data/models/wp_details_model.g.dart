// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wp_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WpDetailsModel _$WpDetailsModelFromJson(Map<String, dynamic> json) =>
    WpDetailsModel(
      ID: json['ID'] as String?,
      user_login: json['user_login'] as String?,
      user_pass: json['user_pass'] as String?,
      user_nicename: json['user_nicename'] as String?,
      user_email: json['user_email'] as String?,
      user_url: json['user_url'] as String?,
      user_registered: json['user_registered'] as String?,
      user_activation_key: json['user_activation_key'] as String?,
      user_status: json['user_status'] as String?,
      display_name: json['display_name'] as String?,
    );

Map<String, dynamic> _$WpDetailsModelToJson(WpDetailsModel instance) =>
    <String, dynamic>{
      'ID': instance.ID,
      'user_login': instance.user_login,
      'user_pass': instance.user_pass,
      'user_nicename': instance.user_nicename,
      'user_email': instance.user_email,
      'user_url': instance.user_url,
      'user_registered': instance.user_registered,
      'user_activation_key': instance.user_activation_key,
      'user_status': instance.user_status,
      'display_name': instance.display_name,
    };
