import 'package:flutter/material.dart';

import '../models/meal.dart';

class ScreenArguments {
  final Meal meal;
  final Color color;

  const ScreenArguments(this.meal, this.color);
}

class MealDetailPage extends StatelessWidget {
  static const routeName = '/meal-detail';

  final Function _toggleFavoriteHandler;
  final Function _isFavoriteHandler;

  const MealDetailPage(this._toggleFavoriteHandler, this._isFavoriteHandler);

  Widget buildSectionTitle(BuildContext context, String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(title, style: Theme.of(context).textTheme.title),
    );
  }

  Widget buildSection(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 200,
      width: 300,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    final meal = args.meal;
    final color = args.color;

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        backgroundColor: color,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                meal.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            buildSectionTitle(context, 'Ingredients'),
            buildSection(
              ListView.builder(
                  itemBuilder: (ctx, index) => Card(
                        color: Colors.white60,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: Text(meal.ingredients[index]),
                        ),
                      ),
                  itemCount: meal.ingredients.length),
            ),
            buildSectionTitle(context, 'Steps'),
            buildSection(
              ListView.builder(
                  itemBuilder: (ctx, index) => Column(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                              child: Text('# ${index + 1}'),
                            ),
                            title: Text(meal.steps[index]),
                          ),
                          Divider()
                        ],
                      ),
                  itemCount: meal.steps.length),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _toggleFavoriteHandler(meal.id),
        child: Icon(_isFavoriteHandler(meal.id)
            ? Icons.favorite
            : Icons.favorite_border),
      ),
    );
  }
}
