import 'package:json_annotation/json_annotation.dart';
import 'movie_model.dart';

part 'toggle_favorite_response_model.g.dart';

@JsonSerializable()
class ToggleFavoriteResponseModel {
  final MovieModel movie;
  final String action;

  const ToggleFavoriteResponseModel({
    required this.movie,
    required this.action,
  });

  factory ToggleFavoriteResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return ToggleFavoriteResponseModel(
      movie: MovieModel.fromJson(data['movie'] as Map<String, dynamic>),
      action: data['action'] as String,
    );
  }

  Map<String, dynamic> toJson() => _$ToggleFavoriteResponseModelToJson(this);
}
