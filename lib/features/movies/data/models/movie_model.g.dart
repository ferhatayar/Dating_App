
part of 'movie_model.dart';


MovieModel _$MovieModelFromJson(Map<String, dynamic> json) => MovieModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      posterUrl: json['posterUrl'] as String,
      genre: json['genre'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );

Map<String, dynamic> _$MovieModelToJson(MovieModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'posterUrl': instance.posterUrl,
      'genre': instance.genre,
      'isFavorite': instance.isFavorite,
    };
