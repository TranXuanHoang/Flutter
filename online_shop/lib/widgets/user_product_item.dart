import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final Product product;

  const UserProductItem({
    Key key,
    @required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(product.imageUrl),
          ),
          title: Text(product.title),
          trailing: Container(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      EditProductScreen.routeName,
                      arguments: product.id,
                    );
                  },
                  color: Theme.of(context).primaryColor,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    Future<bool> deleteConfirm = showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => AlertDialog(
                        title: Text('Are you sure?'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text(
                                'Are you sure you want to delete this product',
                              ),
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(product.imageUrl),
                                ),
                                title: Text(product.title),
                                subtitle: Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                ),
                              )
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Yes'),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                          FlatButton(
                            child: Text('No'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                        ],
                      ),
                    );
                    deleteConfirm.then((wantToDelete) {
                      if (wantToDelete == true) {
                        Provider.of<Products>(context, listen: false)
                            .deleteProduct(product.id);
                      }
                    });
                  },
                  color: Theme.of(context).errorColor,
                ),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
