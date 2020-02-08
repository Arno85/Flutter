import 'package:flutter/material.dart';
import 'package:shop_app/models/cart_item.dart';
import 'package:shop_app/models/order_item.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  int get orderCount {
    return _orders.length;
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      new OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        products: cartProducts,
        orderPlaced: DateTime.now(),
      ),
    );

    notifyListeners();
  }
}
