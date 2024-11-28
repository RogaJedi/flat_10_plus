import 'package:equatable/equatable.dart';

class Cart extends Equatable {
  final int cartId;
  final int userId;
  final int productId;
  late final int quantity;

  Cart({
    required this.cartId,
    required this.userId,
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object> get props => [cartId, userId, productId, quantity];
}