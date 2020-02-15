import 'package:flutter/material.dart';
import 'package:shop_app/models/cart_item.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/models/order_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  int get orderCount {
    return _orders.length;
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://learning-flutter-arno85.firebaseio.com/orders.json';

    final timestamp = DateTime.now();

    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'orderPlaced': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );

    print(response);

    if (response.statusCode >= 400) {
      throw new HttpException('Could not save the order');
    }

    _orders.insert(
      0,
      new OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        orderPlaced: timestamp,
      ),
    );

    notifyListeners();
  }

  Future<void> getOrders() async {
    const url = 'https://learning-flutter-arno85.firebaseio.com/orders.json';

    final response = await http.get(url);
    final ordersFromDb = json.decode(response.body) as Map<String, dynamic>;

    if (ordersFromDb == null) {
      return;
    }

    _orders.clear();
    ordersFromDb.forEach((orderId, orderData) => {
          _orders.add(
            OrderItem(
                id: orderId,
                amount: orderData['amount'],
                orderPlaced: DateTime.parse(orderData['orderPlaced']),
                products: (orderData['products'] as List<dynamic>)
                    .map(
                      (item) => CartItem(
                          id: item['id'],
                          title: item['title'],
                          quantity: item['quantity'],
                          price: item['price']),
                    )
                    .toList()),
          )
        });

    _orders.sort((b, a) => a.orderPlaced.compareTo(b.orderPlaced));
    notifyListeners();
  }
}
