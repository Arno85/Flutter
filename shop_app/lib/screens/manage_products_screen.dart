import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/manage_product_item.dart';

import 'edit_product_screen.dart';

class ManageProductsScreen extends StatelessWidget {
  static const route = '/manage-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context).getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.route),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Consumer<Products>(
            builder: (ctx, products, ch) => ListView.builder(
              itemCount: products.getCount,
              itemBuilder: (ctx, i) => Column(
                children: <Widget>[
                  ManageProductItem(products.items[i]),
                  Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
