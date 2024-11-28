
import '../models/cart.dart';

class CartList {
  static List<Cart> _carts = [];

  static List<Cart> get carts => _carts;

  static void addCart(Cart cart) {
    if(!_carts.any((c) => c.productId == cart.productId)) {
      _carts.add(cart);
    }
  }

  static int getQuantity(int productId) {
    final cart = _carts.firstWhere(
          (c) => c.productId == productId,
      orElse: () => Cart(cartId: 0, userId: 0, productId: productId, quantity: 0),
    );
    return cart.quantity;
  }

  static void incrementQuantity(int productId) {
    final cartIndex = _carts.indexWhere((c) => c.productId == productId);
    if (cartIndex != -1) {
      final updatedCart = Cart(
        cartId: _carts[cartIndex].cartId,
        userId: _carts[cartIndex].userId,
        productId: _carts[cartIndex].productId,
        quantity: _carts[cartIndex].quantity + 1,
      );
      _carts[cartIndex] = updatedCart;
    }
  }

  static void decrementQuantity(int productId) {
    final cartIndex = _carts.indexWhere((c) => c.productId == productId);
    if (cartIndex != -1 && _carts[cartIndex].quantity > 1) {
      final updatedCart = Cart(
        cartId: _carts[cartIndex].cartId,
        userId: _carts[cartIndex].userId,
        productId: _carts[cartIndex].productId,
        quantity: _carts[cartIndex].quantity - 1,
      );
      _carts[cartIndex] = updatedCart;
    }
  }

  static void removeCart(int productId) {
    _carts.removeWhere((c) => c.productId == productId);
  }

}