import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/meal.dart';

import 'models/filters.dart';
import 'pages/filters_page.dart';
import 'pages/tabs_page.dart';
import 'pages/meal_detail_page.dart';
import 'pages/categories_page.dart';
import 'pages/category_meals_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  static const appTitle = 'Deli Meals';

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _currentFilters = Filters();

  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favoriteMeals = [];

  void _setFilters(Filters filterData) {
    setState(() {
      _currentFilters = filterData;
      _availableMeals = DUMMY_MEALS.where((meal) {
        if (_currentFilters.glutenFree && !meal.isGlutenFree) {
          return false;
        }
        if (_currentFilters.lactoseFree && !meal.isLactoseFree) {
          return false;
        }
        if (_currentFilters.vegan && !meal.isVegan) {
          return false;
        }
        if (_currentFilters.vegetarian && !meal.isVegetarian) {
          return false;
        }

        return true;
      }).toList();
    });
  }

  void _toggleFavorite(String mealId) {
    final existingIndex = _favoriteMeals.indexWhere((meal) => meal.id == mealId);

    if(existingIndex >= 0) {
      setState(() {
        _favoriteMeals.removeAt(existingIndex);
      });
    } else {
      setState(() {
        _favoriteMeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId));
      });
    }   
  }

  bool isMealFavorite(String mealId){
    return _favoriteMeals.any((meal) => meal.id == mealId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyApp.appTitle,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              body1: TextStyle(
                color: Color.fromRGBO(20, 20, 51, 1),
              ),
              body2: TextStyle(
                color: Color.fromRGBO(20, 20, 51, 1),
              ),
              title: TextStyle(
                  fontSize: 20,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.bold),
            ),
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => TabsPage(_favoriteMeals),
        CategoryMealsPage.routeName: (ctx) =>
            CategoryMealsPage(_availableMeals),
        MealDetailPage.routeName: (ctx) => MealDetailPage(_toggleFavorite, isMealFavorite),
        FiltersPage.routeName: (ctx) => FiltersPage(_currentFilters, _setFilters)
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => CategoriesPage(),
        );
      },
    );
  }
}
