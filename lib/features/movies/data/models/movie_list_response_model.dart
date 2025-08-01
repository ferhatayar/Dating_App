import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/movie_list_response.dart';
import 'movie_model.dart';

part 'movie_list_response_model.g.dart';

@JsonSerializable()
class MovieListResponseModel extends MovieListResponse {
  @JsonKey(name: 'movies')
  final List<MovieModel> movieModels;

  const MovieListResponseModel({
    required this.movieModels,
    required super.totalPages,
    required super.currentPage,
  }) : super(movies: movieModels);

  factory MovieListResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final pagination = data['pagination'] as Map<String, dynamic>;
    final moviesList = data['movies'] as List;

    return MovieListResponseModel(
      movieModels: moviesList.map((movie) => MovieModel.fromJson(movie as Map<String, dynamic>)).toList(),
      totalPages: pagination['maxPage'] as int,
      currentPage: pagination['currentPage'] as int,
    );
  }

  Map<String, dynamic> toJson() => _$MovieListResponseModelToJson(this);
}
