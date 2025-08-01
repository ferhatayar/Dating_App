import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../constants/api_constants.dart';
import '../../features/auth/data/models/auth_response_model.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/auth/data/models/upload_photo_response_model.dart';
import '../../features/auth/data/models/profile_response_model.dart';
import '../../features/movies/data/models/movie_list_response_model.dart';
import '../../features/movies/data/models/favorite_movies_response_model.dart';
import '../../features/movies/data/models/toggle_favorite_response_model.dart';


part 'api_client.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  // Auth endpoints
  @POST(ApiConstants.login)
  Future<AuthResponseModel> login(@Body() Map<String, dynamic> body);

  @POST(ApiConstants.register)
  Future<AuthResponseModel> register(@Body() Map<String, dynamic> body);

  @GET(ApiConstants.profile)
  Future<ProfileResponseModel> getProfile();

  @POST(ApiConstants.uploadPhoto)
  Future<UploadPhotoResponseModel> uploadPhoto(@Body() FormData formData);

  // Movie endpoints
  @GET(ApiConstants.movieList)
  Future<MovieListResponseModel> getMovies(@Query('page') int page);

  @GET(ApiConstants.favorites)
  Future<FavoriteMoviesResponseModel> getFavoriteMovies(@Query('page') int page);

  @POST('${ApiConstants.addFavorite}/{movieId}')
  Future<ToggleFavoriteResponseModel> toggleFavorite(@Path('movieId') String movieId);
}
