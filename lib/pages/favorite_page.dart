import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../favorite_bloc/favorite_bloc.dart';
import '../favorite_bloc/favorite_state.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class FavoritePage extends StatelessWidget {
  final List<Product> productList;

  const FavoritePage({
    Key? key,
    required this.productList,
  }) : super(key: key);

  Product getProduct(int favoriteId) {
    return productList.firstWhere((product) => product.productId == favoriteId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Избранное"),
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          final favoriteList = state.favorites;
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: favoriteList.length,
            itemBuilder: (BuildContext context, int index) {
              final product = getProduct(favoriteList[index].productId);
              return ProductCard(product: product);
            },
          );
        },
      ),
    );
  }

}
