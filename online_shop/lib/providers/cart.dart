import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  final int quantity;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
    @required this.price,
    @required this.quantity,
  });
}

class Cart with ChangeNotifier {
  // Each element is a map of 'Product.id' and 'CartItem'
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((productId, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem({
    @required String productId,
    @required double price,
    @required String title,
    @required String imageUrl,
  }) {
    if (_items.containsKey(productId)) {
      // Already exist the same item, so just increase the quantity
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          imageUrl: existingCartItem.imageUrl,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      // Add a new item
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          imageUrl: imageUrl,
          price: price,
          quantity: 1,
        ),
      );
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
