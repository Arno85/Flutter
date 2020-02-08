import 'package:flutter/material.dart';
import 'package:shop_app/models/cart_item.dart';

class OrderProductItem extends StatelessWidget {
  final CartItem product;

  const OrderProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '- ${product.title}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          '${product.quantity}x \$${product.price}',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
