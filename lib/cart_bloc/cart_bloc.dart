import 'package:flutter_bloc/flutter_bloc.dart';
import '../api/cart_list.dart';
import '../cart_bloc/cart_event.dart';
import '../cart_bloc/cart_state.dart';
import '../models/cart.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState(carts: List.from(CartList.carts), quantity: 0)) {
    on<AddCartEvent>(_onAddCart);
    on<IncrementQuantityEvent>(_onIncrementQuantity);
    on<DecrementQuantityEvent>(_onDecrementQuantity);
    on<RemoveCartEvent>(_onRemoveCart);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
  }

  void _onAddCart(AddCartEvent event, Emitter<CartState> emit) {
    CartList.addCart(Cart(
        cartId: DateTime.now().millisecondsSinceEpoch,
        userId: 0,
        productId: event.productId,
        quantity: 1
    ));
    emit(CartState(carts: List.from(CartList.carts), quantity: CartList.getQuantity(event.productId)));
  }

  void _onIncrementQuantity(IncrementQuantityEvent event, Emitter<CartState> emit) {
    CartList.incrementQuantity(event.productId);
    emit(CartState(carts: List.from(CartList.carts), quantity: CartList.getQuantity(event.productId)));
  }

  void _onDecrementQuantity(DecrementQuantityEvent event, Emitter<CartState> emit) {
    CartList.decrementQuantity(event.productId);
    emit(CartState(carts: List.from(CartList.carts), quantity: CartList.getQuantity(event.productId)));
  }

  void _onRemoveCart(RemoveCartEvent event, Emitter<CartState> emit) {
    CartList.removeCart(event.productId);
    emit(CartState(carts: List.from(CartList.carts), quantity: 0));
  }

  void _onUpdateQuantity(UpdateQuantityEvent event, Emitter<CartState> emit) {
    emit(CartState(carts: state.carts, quantity: CartList.getQuantity(event.productId)));
  }
}

