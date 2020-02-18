import 'package:flutter/material.dart';
import 'package:great_places_app/providers/places.dart';
import 'package:great_places_app/screens/place_detail_screen.dart';
import 'package:provider/provider.dart';

import 'add_place_screen.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(AddPlaceScreen.route),
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<Places>(context, listen: false).getPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : Consumer<Places>(
                child: Center(
                  child: Text('There is no places yet, Start adding some!'),
                ),
                builder: (ctx, placesProvider, ch) =>
                    placesProvider.places.length <= 0
                        ? ch
                        : ListView.builder(
                            itemCount: placesProvider.places.length,
                            itemBuilder: (ctx, i) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    FileImage(placesProvider.places[i].image),
                              ),
                              title: Text(placesProvider.places[i].title),
                              subtitle: Text(
                                  placesProvider.places[i].location.address),
                              onTap: () => Navigator.of(context).pushNamed(PlaceDetailScreen.route, arguments: placesProvider.places[i].id),
                            ),
                          ),
              ),
      ),
    );
  }
}
