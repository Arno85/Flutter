import 'package:flutter/material.dart';

import '../data/dummy_products.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = dummyProducts;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  int get getCount {
    return _items.length;
  }

  void addProduct(Product product) {
    final newProduct = Product(
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      id: DateTime.now().toString(),
    );

    _items.insert(0, newProduct);
    notifyListeners();
  }

  void updateProduct(Product product) {
    final prodIndex = _items.indexWhere((item) => item.id == product.id);

    if(prodIndex >= 0) {
      _items[prodIndex] = product;
      notifyListeners();
    }
  }

  void deleteProduct(Product product){
    _items.remove(product);
    notifyListeners();
  }
}
