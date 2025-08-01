import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'profile_response_model.g.dart';

@JsonSerializable()
class ProfileResponseModel {
  final UserModel user;

  const ProfileResponseModel({required this.user});

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return ProfileResponseModel(
      user: UserModel.fromJson(data),
    );
  }

  Map<String, dynamic> toJson() => _$ProfileResponseModelToJson(this);
}
