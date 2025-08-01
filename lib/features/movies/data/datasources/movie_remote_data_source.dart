import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/movie_list_response_model.dart';
import '../models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<MovieListResponseModel> getMovies(int page);
  Future<List<MovieModel>> getFavoriteMovies(int page);
  Future<void> toggleFavorite(String movieId);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final ApiClient apiClient;

  MovieRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<MovieListResponseModel> getMovies(int page) async {
    try {
      final response = await apiClient.getMovies(page);
      return response;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to get movies',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException('Network error occurred while getting movies');
    }
  }

  @override
  Future<List<MovieModel>> getFavoriteMovies(int page) async {
    try {
      print('🎬 Fetching favorite movies for page $page...');
      final response = await apiClient.getFavoriteMovies(page);
      print('🎬 Favorite movies response: ${response.movies.length} movies');
      return response.movies;
    } on DioException catch (e) {
      print('🎬 DioException in getFavoriteMovies: ${e.response?.data}');
      final errorMessage = e.response?.data['response']?['message'] ?? 'Failed to get favorite movies';
      throw ServerException(
        message: errorMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      print('🎬 Exception in getFavoriteMovies: $e');
      throw NetworkException('Network error occurred while getting favorite movies: ${e.toString()}');
    }
  }

  @override
  Future<void> toggleFavorite(String movieId) async {
    try {
      await apiClient.toggleFavorite(movieId);
      // Response contains movie data and action, but we don't need to return it
      // The UI will handle the state update
    } on DioException catch (e) {
      final errorMessage = e.response?.data['response']?['message'] ?? 'Failed to toggle favorite';
      throw ServerException(
        message: errorMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException('Network error occurred while toggling favorite: ${e.toString()}');
    }
  }
}
