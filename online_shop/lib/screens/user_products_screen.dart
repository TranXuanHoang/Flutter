import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './edit_product_screen.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _refreshProducts(BuildContext context) async {
    try {
      await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
    } catch (error) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            'Loading products failed!',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: (context, index) => UserProductItem(
              product: productsData.items[index],
            ),
            itemCount: productsData.items.length,
          ),
        ),
      ),
    );
  }
}
