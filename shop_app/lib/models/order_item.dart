import 'package:flutter/foundation.dart';
import 'package:shop_app/models/cart_item.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime orderPlaced;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.orderPlaced,
  });
}
