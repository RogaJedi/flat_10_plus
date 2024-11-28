import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cart_bloc/cart_bloc.dart';
import '../cart_bloc/cart_state.dart';
import '../models/product.dart';
import '../widgets/cart_product_card.dart';

class CartPage extends StatelessWidget {

  final List<Product> productList;

  const CartPage({
    Key? key,
    required this.productList,
  }) : super(key: key);

  Product getProduct(int cartId) {
    return productList.firstWhere((product) => product.productId == cartId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Корзина"),
        ),
        body: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              final cartList = state.carts;
              return Center(
                  child: ListView.builder(
                    itemCount: cartList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final product = getProduct(cartList[index].productId);
                      return CartProductCard(product: product);
                    },
                  )
              );
            }
        )
    );
  }
}
/*
Center(
        child: ListView.builder(
          itemCount: productList.length,
          itemBuilder: (BuildContext context, int index) {
            final product = getProduct(productList[index].productId);
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CartProductCard(
                product: product,
                quantity: productList[index].price,
              )],
            );
          },
        ),
      ),
 */