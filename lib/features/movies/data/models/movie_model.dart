import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/movie.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.description,
    required super.posterUrl,
    super.genre,
    super.isFavorite = false,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    
    String posterUrl = json['Poster'] as String;
    if (posterUrl.startsWith('http://')) {
      posterUrl = posterUrl.replaceFirst('http://', 'https://');
    }

    return MovieModel(
      id: json['_id'] as String? ?? json['id'] as String,
      title: json['Title'] as String,        
      description: json['Plot'] as String,   
      posterUrl: posterUrl,                  
      genre: json['Genre'] as String?,       
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

  factory MovieModel.fromEntity(Movie movie) {
    return MovieModel(
      id: movie.id,
      title: movie.title,
      description: movie.description,
      posterUrl: movie.posterUrl,
      isFavorite: movie.isFavorite,
    );
  }
}
