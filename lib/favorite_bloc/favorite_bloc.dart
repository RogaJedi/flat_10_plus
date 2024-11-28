import 'package:flat_10plus/api/favorite_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

//TODO: THIS CODE DOESN'T FVCKING WORK FIX IT U BOZO >:[

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteApi favoriteApi;

  FavoriteBloc({required this.favoriteApi}) : super(FavoriteState(favorites: [])) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
  }

  Future<void> _onLoadFavorites(LoadFavoritesEvent event, Emitter<FavoriteState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final favorites = await favoriteApi.getFavorites(event.userId);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onToggleFavorite(ToggleFavoriteEvent event, Emitter<FavoriteState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final isFavorite = state.favorites.any((f) => f.productId == event.productId);
      if (isFavorite) {
        await favoriteApi.removeFromFavorites(event.userId, event.productId);
        final updatedFavorites = state.favorites.where((f) => f.productId != event.productId).toList();
        emit(state.copyWith(favorites: updatedFavorites, isLoading: false));
      } else {
        await favoriteApi.addToFavorites(event.userId, event.productId);
        // Create a new Favorite object manually
        final newFavorite = Favorite( // Use a temporary ID
          userId: event.userId,
          productId: event.productId,
        );
        emit(state.copyWith(favorites: [...state.favorites, ], isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onRemoveFavorite(RemoveFavoriteEvent event, Emitter<FavoriteState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await favoriteApi.removeFromFavorites(event.userId, event.productId);
      final updatedFavorites = state.favorites.where((f) => f.productId != event.productId).toList();
      emit(state.copyWith(favorites: updatedFavorites, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
