import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:great_places_app/helpers/db_helper.dart';
import 'package:great_places_app/helpers/location_helper.dart';
import 'package:great_places_app/models/place.dart';

class Places with ChangeNotifier {
  List<Place> _places = [];

  List<Place> get places {
    return [..._places];
  }

  Place findById(String id) {
    return _places.firstWhere((place) => place.id == id);
  }

  Future<void> addPlace(
      String title, File image, PlaceLocation location) async {
    final newAddress = await LocationHelper.getPlaceaddress(
      location.latitude,
      location.longitude,
    );

    final newLocation = PlaceLocation(
      latitude: location.latitude,
      longitude: location.longitude,
      address: newAddress,
    );

    final newPlace = Place(
      id: DateTime.now().toString(),
      image: image,
      title: title,
      location: newLocation,
    );

    _places.add(newPlace);

    notifyListeners();

    DbHelper.insert(DbHelper.placesTableName, {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_lng': newPlace.location.longitude,
      'address': newPlace.location.address,
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
            location: PlaceLocation(
              latitude: p['loc_lat'],
              longitude: p['loc_lng'],
              address: p['address'],
            ),
          ),
        )
        .toList();

    notifyListeners();
  }
}
