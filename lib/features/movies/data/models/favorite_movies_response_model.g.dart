
part of 'favorite_movies_response_model.dart';


FavoriteMoviesResponseModel _$FavoriteMoviesResponseModelFromJson(
        Map<String, dynamic> json) =>
    FavoriteMoviesResponseModel(
      movies: (json['movies'] as List<dynamic>)
          .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FavoriteMoviesResponseModelToJson(
        FavoriteMoviesResponseModel instance) =>
    <String, dynamic>{
      'movies': instance.movies,
    };
