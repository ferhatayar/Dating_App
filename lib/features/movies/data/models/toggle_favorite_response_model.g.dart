
part of 'toggle_favorite_response_model.dart';


ToggleFavoriteResponseModel _$ToggleFavoriteResponseModelFromJson(
        Map<String, dynamic> json) =>
    ToggleFavoriteResponseModel(
      movie: MovieModel.fromJson(json['movie'] as Map<String, dynamic>),
      action: json['action'] as String,
    );

Map<String, dynamic> _$ToggleFavoriteResponseModelToJson(
        ToggleFavoriteResponseModel instance) =>
    <String, dynamic>{
      'movie': instance.movie,
      'action': instance.action,
    };
