
part of 'movie_list_response_model.dart';


MovieListResponseModel _$MovieListResponseModelFromJson(
        Map<String, dynamic> json) =>
    MovieListResponseModel(
      movieModels: (json['movies'] as List<dynamic>)
          .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: (json['totalPages'] as num).toInt(),
      currentPage: (json['currentPage'] as num).toInt(),
    );

Map<String, dynamic> _$MovieListResponseModelToJson(
        MovieListResponseModel instance) =>
    <String, dynamic>{
      'totalPages': instance.totalPages,
      'currentPage': instance.currentPage,
      'movies': instance.movieModels,
    };
