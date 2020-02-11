import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.route,
              arguments: product,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: () => product.toggleFavoriteStatus(),
                color: Theme.of(context).accentColor),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () => {
                    cart.addItem(product),
                    Scaffold.of(context).hideCurrentSnackBar(),
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added item to cart!'),
                        duration: Duration(seconds: 3),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () => cart.removeSingle(product.id),
                        ),
                      ),
                    )
                  },
              color: Theme.of(context).accentColor),
        ),
      ),
    );
  }
}