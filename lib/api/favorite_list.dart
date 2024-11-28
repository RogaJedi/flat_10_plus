
import '../models/favorite.dart';

class FavoriteList {
  static List<Favorite> _favorites = [];

  static List<Favorite> get favorites => _favorites;

  static void addFavorite(Favorite favorite) {
    if (!_favorites.any((f) => f.productId == favorite.productId)) {
      _favorites.add(favorite);
    }
  }

  static void removeFavorite(int productId) {
    _favorites.removeWhere((f) => f.productId == productId);
  }

  static bool isFavorite(int productId) {
    return _favorites.any((f) => f.productId == productId);
  }
}
