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

  void addProduct() {
    // _items.add(value);
    notifyListeners();
  }
}
