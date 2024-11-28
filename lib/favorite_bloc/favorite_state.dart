import 'package:equatable/equatable.dart';
import '../models/favorite.dart';

class FavoriteState extends Equatable {
  final List<Favorite> favorites;
  final bool isLoading;
  final String? error;

  const FavoriteState({
    required this.favorites,
    this.isLoading = false,
    this.error,
  });

  @override
  List<Object?> get props => [favorites, isLoading, error];

  FavoriteState copyWith({
    List<Favorite>? favorites,
    bool? isLoading,
    String? error,
  }) {
    return FavoriteState(
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
