class Config {
  // static const String apiURL = '192.168.1.8:1802';
  static const String apiURL = '192.168.1.15:1802'; /* ==> Velasco */
  static const String loginAPI = '/api/users/login';
  static const String isValidTokenAPI = '/api/users/isValidToken';
  static const String getProducts = '/api/offers';
  static const String getProductById = '/api/offers/getById';
  static const String getFavorites = '/api/favorites';
  static const String addFavorite = '/api/favorites/addFavorite';
  static const String removeFavorite = '/api/favorites/removeFavorite';
  static const String updateFavorite = '/api/favorites/updateFavorites';
}
