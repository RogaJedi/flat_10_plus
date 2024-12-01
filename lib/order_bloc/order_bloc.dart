import 'package:flat_10plus/api/cart_api.dart';
import 'package:flat_10plus/api/order_api.dart';
import 'package:flat_10plus/api/product_api.dart';
import 'package:flat_10plus/cart_bloc/cart_bloc.dart';
import 'package:flat_10plus/models/order.dart';
import 'package:flat_10plus/models/product.dart';
import 'package:flat_10plus/order_bloc/order_event.dart';
import 'package:flat_10plus/order_bloc/order_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderApi _orderApi;
  final ProductApi _productApi;
  final CartBloc _cartBloc;
  final CartApi _cartApi;

  OrderBloc(this._orderApi, this._productApi, this._cartBloc, this._cartApi) : super(const OrderState()) {
    on<LoadOrders>(_onLoadOrders);
    on<CreateOrder>(_onCreateOrder);
  }

  Future<void> _onLoadOrders(LoadOrders event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      final orders = await _orderApi.getOrders(event.userId);
      emit(state.copyWith(
        status: OrderStatus.success,
        orders: orders,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrderStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  //TODO: FIX _onCreateOrder !!

  Future<void> _onCreateOrder(CreateOrder event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      final cartState = _cartBloc.state;
      final cartList = _cartApi.getCart(0);
      print('--------');
      print(cartList);
      print('--------');
      double total = 0;
      List<Product> productsInTheCart = [];

      for (var cartItem in cartState.carts) {
        try {
          Product thisProduct = await _productApi.getProduct(cartItem.productId);
          total += thisProduct.price * cartItem.quantity;
          productsInTheCart.add(thisProduct);
        } catch (e) {
          emit(state.copyWith(
            status: OrderStatus.failure,
            errorMessage: 'Failed to fetch product: ${cartItem.productId}',
          ));
          return;
        }
      }

      final newOrder = Order(
        userId: 0,
        total: total,
        status: 'pending',
        products: productsInTheCart,
      );

      final createdOrder = await _orderApi.createOrder(newOrder);

      final updatedOrders = List<Order>.from(state.orders)..add(createdOrder);

      emit(state.copyWith(
        status: OrderStatus.success,
        orders: updatedOrders,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrderStatus.failure,
        errorMessage: 'Failed to create order: ${e.toString()}',
      ));
    }
  }
}