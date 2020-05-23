import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // set 'listen' to false to only get the product data first time without
    // continuing to listen to the data change event. This is to avoid
    // re-building the whole ClipRRect and its child widgets.
    final product = Provider.of<Product>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product.id,
          );
        },
        child: GridTile(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            // Use Consumer here to only rebuild the favorite IconButton
            // when the state changes
            leading: Consumer<Product>(
              builder: (context, product, child) => IconButton(
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  product.toggleIsFavorite(auth.token);
                },
              ),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: Consumer<Cart>(
              builder: (context, cart, child) => IconButton(
                icon: Icon(Icons.shopping_cart),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  cart.addItem(
                    productId: product.id,
                    price: product.price,
                    title: product.title,
                    imageUrl: product.imageUrl,
                  );
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Added item to cart!',
                        textAlign: TextAlign.center,
                      ),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
