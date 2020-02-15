import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item_widget.dart';

class OrdersScreen extends StatelessWidget {
  static const route = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).getOrders(),
        builder: (ctx, dataSnapshot) {

          if (dataSnapshot.error != null) {
            return Center(
              child: Text('An error occured!'),
            );
          }

          return dataSnapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<Orders>(
                  builder: (ctx, ordersProvider, child) => ListView.builder(
                    itemCount: ordersProvider.orderCount,
                    itemBuilder: (ctx, i) =>
                        OrderItemWidget(ordersProvider.orders[i]),
                  ),
                );
        },
      ),
    );
  }
}
