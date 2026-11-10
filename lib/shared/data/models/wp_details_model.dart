import 'package:json_annotation/json_annotation.dart';
part 'wp_details_model.g.dart';

@JsonSerializable()
class WpDetailsModel{
  String? ID;
  String? user_login;
  String? user_pass;
  String? user_nicename;
  String? user_email;
  String? user_url;
  String? user_registered;
  String? user_activation_key;
  String? user_status;
  String? display_name;

  WpDetailsModel({
    this.ID,
    this.user_login,
    this.user_pass,
    this.user_nicename,
    this.user_email,
    this.user_url,
    this.user_registered,
    this.user_activation_key,
    this.user_status,
    this.display_name,
  });

  factory WpDetailsModel.fromJson(Map json) => _$WpDetailsModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$WpDetailsModelToJson(this);

}
