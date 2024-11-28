import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cart_bloc/cart_bloc.dart';
import '../cart_bloc/cart_event.dart';
import '../cart_bloc/cart_state.dart';
import '../models/cart.dart';
import '../pages/product_related/product_page.dart';
import '../models/product.dart';

class CartProductCard extends StatelessWidget {
  final Product product;

  CartProductCard({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 400,
        height: 150,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      ProductPage(productId: product.productId)
                  ),
                );
              },
              child: Card(
                color: Colors.white,
                child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          color: Colors.lightBlueAccent,
                          child: const Center(
                            child: Text(
                                "IMG",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                )
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(color: Colors.black, fontSize: 30),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              product.price.toString(),
                              style: const TextStyle(color: Colors.black, fontSize: 30),
                            ),
                          ],
                        ),
                        const SizedBox(width: 40),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BlocBuilder<CartBloc, CartState> (
                                builder: (context, state) {
                                  int currentQuantity = 0;
                                  Cart? currentCart = state.carts.firstWhere(
                                        (cart) => cart.productId == product.productId,
                                  );
                                  currentQuantity = currentCart.quantity;
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            context.read<CartBloc>().add(DecrementQuantityEvent(product.productId));
                                            context.read<CartBloc>().add(UpdateQuantityEvent(product.productId));
                                          },
                                          icon: const Icon(Icons.remove_circle)
                                      ),
                                      Text('$currentQuantity'),
                                      IconButton(
                                          onPressed: () {
                                            context.read<CartBloc>().add(IncrementQuantityEvent(product.productId));
                                            context.read<CartBloc>().add(UpdateQuantityEvent(product.productId));
                                          },
                                          icon: const Icon(Icons.add_circle)
                                      ),
                                    ],
                                  );
                                }
                            ),
                            BlocBuilder<CartBloc, CartState> (
                                builder: (context, state) {
                                  return IconButton(
                                      onPressed: () {
                                        context.read<CartBloc>().add(RemoveCartEvent(productId: product.productId));
                                      },
                                      icon: const Icon(Icons.delete)
                                  );
                                }
                            ),
                          ],
                        )
                      ],
                    )
                ),
              ),
            ),
          ],
        )
    );
  }
}

/*
Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BlocBuilder<CartBloc, CartState> (
                                    builder: (context, state) {
                                      return IconButton(
                                          onPressed: () {
                                            context.read<CartBloc>().add(DecrementQuantityEvent(product.productId));
                                          },
                                          icon: const Icon(Icons.remove_circle)
                                      );
                                    }
                                ),
                                BlocBuilder<CartBloc, CartState>(
                                    builder: (context, state) {
                                      // Get the quantity for this product
                                      int quantity = CartList.getQuantity(product.productId);
                                      // Display the quantity
                                      return Text('$quantity');
                                    }
                                ),
                                BlocBuilder<CartBloc, CartState> (
                                    builder: (context, state) {
                                      return IconButton(
                                          onPressed: () {
                                            context.read<CartBloc>().add(IncrementQuantityEvent(product.productId));
                                          },
                                          icon: const Icon(Icons.add_circle)
                                      );
                                    }
                                ),
                              ],
                            ),
 */

