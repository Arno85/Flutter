import 'package:flutter/material.dart';

import '../providers/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static const route = 'product-detail';

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context).settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${product.price}',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                product.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
