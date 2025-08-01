class ApiConstants {
  static const String baseUrl = 'https://caseapi.servicelabs.tech';
  
  // Auth endpoints
  static const String login = '/user/login';
  static const String register = '/user/register';
  static const String profile = '/user/profile';
  static const String uploadPhoto = '/user/upload_photo';
  
  // Movie endpoints
  static const String movieList = '/movie/list';
  static const String favorites = '/movie/favorites';
  static const String addFavorite = '/movie/favorite';
  
  // Headers
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
  
  // Pagination
  static const int pageSize = 5;
  static const int maxPages = 4;
  
  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}
