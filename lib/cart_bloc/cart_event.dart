import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddCartEvent extends CartEvent {
  final int productId;

  const AddCartEvent(this.productId);

  @override
  List<Object> get props => [productId];
}

class UpdateQuantityEvent extends CartEvent {
  final int productId;

  UpdateQuantityEvent(this.productId);
}

class IncrementQuantityEvent extends CartEvent {
  final int productId;

  const IncrementQuantityEvent(this.productId);

  @override
  List<Object> get props => [productId];
}

class DecrementQuantityEvent extends CartEvent {
  final int productId;

  const DecrementQuantityEvent(this.productId);

  @override
  List<Object> get props => [productId];
}

class RemoveCartEvent extends CartEvent {
  final int productId;

  const RemoveCartEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}
