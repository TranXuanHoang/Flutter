import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  FilterOptions _filterOption = FilterOptions.All;

  bool _showOnlyFavorites() {
    switch (_filterOption) {
      case FilterOptions.Favorites:
        return true;
      case FilterOptions.All:
        return false;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products Overview'),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(
                  'Show Favorites',
                ),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text(
                  'Show All',
                ),
                value: FilterOptions.All,
              ),
            ],
            onSelected: (value) {
              setState(() {
                _filterOption = value;
              });
            },
            tooltip: 'Filter Products',
          ),
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites()),
    );
  }
}
