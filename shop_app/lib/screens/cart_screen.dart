import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  static const route = '/cart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Consumer<Cart>(
        builder: (ctx, cart, child) => Column(
          children: <Widget>[
            Card(
              margin: const EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    Chip(
                      elevation: 5,
                      label: Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context).primaryTextTheme.title.color,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    FlatButton(
                      onPressed: () => {
                        Provider.of<Orders>(context, listen: false).addOrder(
                          cart.items.values.toList(),
                          cart.totalAmount,
                        ),
                        cart.clear()
                      },
                      child: const Text('Order Now'),
                      textColor: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (ctx, i) =>
                    CartItemWidget(cart.items.values.toList()[i]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
