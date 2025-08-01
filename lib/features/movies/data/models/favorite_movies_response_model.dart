import 'package:json_annotation/json_annotation.dart';
import 'movie_model.dart';

part 'favorite_movies_response_model.g.dart';

@JsonSerializable()
class FavoriteMoviesResponseModel {
  final List<MovieModel> movies;

  const FavoriteMoviesResponseModel({required this.movies});

  factory FavoriteMoviesResponseModel.fromJson(Map<String, dynamic> json) {
    print('🎬 FavoriteMoviesResponseModel.fromJson called with: $json');
    
    final data = json['data'] as List<dynamic>?;
    if (data == null) {
      print('🎬 No data found in response');
      return const FavoriteMoviesResponseModel(movies: []);
    }
    
    print('🎬 Found ${data.length} movies in data array');
    
    final movies = data.map((movieJson) {
      try {
        return MovieModel.fromJson(movieJson as Map<String, dynamic>);
      } catch (e) {
        print('🎬 Error parsing movie: $e');
        print('🎬 Movie JSON: $movieJson');
        rethrow;
      }
    }).toList();
    
    print('🎬 Successfully parsed ${movies.length} movies');
    return FavoriteMoviesResponseModel(movies: movies);
  }

  Map<String, dynamic> toJson() => _$FavoriteMoviesResponseModelToJson(this);
}
