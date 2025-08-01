
part of 'profile_response_model.dart';


ProfileResponseModel _$ProfileResponseModelFromJson(
        Map<String, dynamic> json) =>
    ProfileResponseModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileResponseModelToJson(
        ProfileResponseModel instance) =>
    <String, dynamic>{
      'user': instance.user,
    };
