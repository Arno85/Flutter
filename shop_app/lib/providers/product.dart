import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  var isFavorite = false;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite});

  Future<void> toggleFavoriteStatus(
      Product product, String authToken, String userId) async {
    var oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final id = product.id;
    final url =
        'https://learning-flutter-arno85.firebaseio.com/userFavorite/$userId/$id.json?auth=$authToken';

    final response = await http.put(
      url,
      body: json.encode(isFavorite),
    );

    if (response.statusCode >= 400) {
      isFavorite = oldStatus;
      notifyListeners();
      throw new HttpException('Could not save the is Favorite status');
    }

    oldStatus = null;
  }
}
