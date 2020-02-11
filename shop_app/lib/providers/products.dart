import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../data/dummy_products.dart';
import './product.dart';

class Products with ChangeNotifier {
  var _url = 'https://learning-flutter-arno85.firebaseio.com/products.json';

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

  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(
        _url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      print(json.decode(response.body));
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
       _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> getProducts() async {
    try {
      final response = await http.get(_url);
      print(json.decode(response.body));
    } catch (error) {
      throw error;
    }
  }

  void updateProduct(Product product) {
    final prodIndex = _items.indexWhere((item) => item.id == product.id);

    if (prodIndex >= 0) {
      _items[prodIndex] = product;
      notifyListeners();
    }
  }

  void deleteProduct(Product product) {
    _items.remove(product);
    notifyListeners();
  }
}
