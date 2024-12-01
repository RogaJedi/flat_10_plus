import 'package:flat_10plus/api/product_api.dart';
import 'package:flat_10plus/models/cart.dart';
import 'package:flat_10plus/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cart_bloc/cart_bloc.dart';
import '../cart_bloc/cart_state.dart';
import '../models/product.dart';
import '../order_bloc/order_bloc.dart';
import '../order_bloc/order_event.dart';
import '../order_bloc/order_state.dart';
import '../widgets/cart_product_card.dart';


class CartPage extends StatelessWidget {
  final ProductApi productApi;

  const CartPage({
    Key? key,
    required this.productApi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, orderState) {
        if (orderState.status == OrderStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Заказ оформлен!')),
          );
        } else if (orderState == OrderStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating order: ${orderState.errorMessage}')),
          );
        }
      },
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          return BlocBuilder<OrderBloc, OrderState>(
            builder: (context, orderState) {
              return _buildScaffold(context, cartState.carts, orderState);
            },
          );
        },
      ),
    );
  }

  Future<Product?> getProduct(int productId) async {
    try {
      return await productApi.getProduct(productId);
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }

  Future<double?> getTotal(List<Cart> carts) async {
    double total = 0;
    for (var cartItem in carts) {
      try {
        Product thisProduct = await productApi.getProduct(cartItem.productId);
        total += thisProduct.price * cartItem.quantity;
      } catch (e) {
        print('Error fetching product: $e');
      }
    }
    print("----------");
    print(total);
    print("----------");
    return total;
  }

  Widget _buildScaffold(BuildContext context, List<Cart> carts, OrderState orderState) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Корзина"),
      ),
      body: carts.isEmpty
          ? const Center(child: Text("Корзина пуста"))
          : Stack(
            children: [
              ListView.builder(
                  itemCount: carts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FutureBuilder<Product?>(
                      future: getProduct(carts[index].productId),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          return CartProductCard(
                            product: snapshot.data!,
                            quantity: carts[index].quantity,
                          );
                        } else {
                          return const Text('Product not found');
                        }
                      },
                    );
                  },
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: kBottomNavigationBarHeight - 55,
                child: Container(
                  padding: EdgeInsets.all(16),
                  color: const Color(0xFF504BFF),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 200,
                        child: FutureBuilder<double?>(
                          future: getTotal(carts),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              return Text(
                                'Итого: ${snapshot.data!.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.white, fontSize: 18),
                              );
                            } else {
                              return Text('No data');
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: orderState.status == OrderStatus.loading
                            ? null
                            : () {
                          context.read<OrderBloc>().add(CreateOrder());
                        },
                        child: orderState.status == OrderStatus.loading
                            ? CircularProgressIndicator()
                            : const Text("Оформить заказ"),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
    );
  }
}
