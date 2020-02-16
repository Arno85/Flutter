import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'dart:convert';

import './product.dart';

class Products with ChangeNotifier {
  final String authToken;
  final String userId;
  final String _baseUrl = 'https://learning-flutter-arno85.firebaseio.com';

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  int get getCount {
    return _items.length;
  }

  Products(this.authToken, this.userId);

  Future<void> getProducts([bool filterByUser = false]) async {
    final filterString = filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    final url =
        '$_baseUrl/products.json?auth=$authToken$filterString';
    final favoriteUrl =
        '$_baseUrl/userFavorite/$userId.json?auth=$authToken';

    try {
      final response = await http.get(url);
      final favResponse = await http.get(favoriteUrl);
      final productsFromDb = json.decode(response.body) as Map<String, dynamic>;
      final favoritesFromDb = json.decode(favResponse.body);

      if (productsFromDb == null) {
        return;
      }

      _items.clear();
      productsFromDb.forEach((prodId, prodData) {
        _items.add(
          Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              imageUrl: prodData['imageUrl'],
              isFavorite: favoritesFromDb == null ? false : favoritesFromDb[prodId] ?? false),
        );
      });

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://learning-flutter-arno85.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId
        }),
      );

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
      throw error;
    }
  }

  Future<void> updateProduct(Product product) async {
    final prodIndex = _items.indexWhere((item) => item.id == product.id);

    if (prodIndex >= 0) {
      final id = product.id;
      final url =
          'https://learning-flutter-arno85.firebaseio.com/products/$id.json?auth=$authToken';

      await http.patch(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
        }),
      );

      _items[prodIndex] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(Product product) async {
    final id = product.id;
    final url =
        'https://learning-flutter-arno85.firebaseio.com/products/$id.json?auth=$authToken';

    var existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = product;

    _items.remove(product);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }
}
