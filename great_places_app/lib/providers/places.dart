import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:great_places_app/helpers/db_helper.dart';
import 'package:great_places_app/models/place.dart';

class Places with ChangeNotifier {
  List<Place> _places = [];

  List<Place> get places {
    return [..._places];
  }

  void addPlace(String title, File image) {
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: image,
      title: title,
      location: null,
    );

    _places.add(newPlace);

    notifyListeners();

    DbHelper.insert(DbHelper.placesTableName, {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
    });
  }

  Future<void> getPlaces() async {
    final placesFromDb = await DbHelper.getData(DbHelper.placesTableName);

    _places = placesFromDb
        .map(
          (p) => Place(
            id: p['id'],
            title: p['title'],
            image: File(p['image']),
            location: null,
          ),
        )
        .toList();

    notifyListeners();
  }
}
