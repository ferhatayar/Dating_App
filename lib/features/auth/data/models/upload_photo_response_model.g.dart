// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_photo_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadPhotoResponseModel _$UploadPhotoResponseModelFromJson(
        Map<String, dynamic> json) =>
    UploadPhotoResponseModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UploadPhotoResponseModelToJson(
        UploadPhotoResponseModel instance) =>
    <String, dynamic>{
      'user': instance.user,
    };
