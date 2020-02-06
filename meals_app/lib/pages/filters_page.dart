import 'package:flutter/material.dart';
import 'package:meals_app/models/filters.dart';
import 'package:meals_app/widgets/drawer_widget.dart';

class FiltersPage extends StatefulWidget {
  static const routeName = '/filters';

  final Function saveFilters;
  final Filters currentFilters;

  FiltersPage(this.currentFilters, this.saveFilters);

  @override
  _FiltersPageState createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  var _filters = Filters();

  @override
  initState() {
    _filters = widget.currentFilters;
    super.initState();
  }

  Widget _buildSwitchListTile(
      String title, String subTitle, bool currentValue, Function updateValue) {
    return SwitchListTile(
      title: Text(title),
      value: currentValue,
      subtitle: Text(subTitle),
      onChanged: updateValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Filters'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                final filters = Filters();
                filters.glutenFree = _filters.vegetarian;
                filters.lactoseFree = _filters.lactoseFree;
                filters.vegan = _filters.vegan;
                filters.vegetarian = _filters.vegetarian;

                widget.saveFilters(filters);
              },
            )
          ],
        ),
        drawer: DrawerWidget(),
        body: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Adjust your meal selection',
                style: Theme.of(context).textTheme.title,
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  _buildSwitchListTile(
                      'Gluten free',
                      'Only include gluten free meals',
                      _filters.glutenFree, (newValue) {
                    setState(() {
                      _filters.glutenFree = newValue;
                    });
                  }),
                  _buildSwitchListTile(
                      'Lactose free',
                      'Only include lactose free meals',
                      _filters.lactoseFree, (newValue) {
                    setState(() {
                      _filters.lactoseFree = newValue;
                    });
                  }),
                  _buildSwitchListTile(
                      'Vegan', 'Only include vegan meals', _filters.vegan, (newValue) {
                    setState(() {
                      _filters.vegan = newValue;
                    });
                  }),
                  _buildSwitchListTile('Vegetarian',
                      'Only include vegetarian meals', _filters.vegetarian, (newValue) {
                    setState(() {
                      _filters.vegetarian = newValue;
                    });
                  }),
                ],
              ),
            )
          ],
        ));
  }
}
