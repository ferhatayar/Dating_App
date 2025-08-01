import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'upload_photo_response_model.g.dart';

@JsonSerializable()
class UploadPhotoResponseModel {
  final UserModel user;

  const UploadPhotoResponseModel({required this.user});

  factory UploadPhotoResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return UploadPhotoResponseModel(
      user: UserModel.fromJson(data),
    );
  }

  Map<String, dynamic> toJson() => _$UploadPhotoResponseModelToJson(this);

  String get photoUrl => user.photoUrl ?? '';
}
