import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' as CartModel;

class CartItem extends StatelessWidget {
  final CartModel.CartItem cartItemModel;
  final String productId;

  CartItem({
    this.cartItemModel,
    this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(productId),
      background: Container(
        color: Theme.of(context).errorColor,
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: 15),
          child: Icon(
            Icons.delete,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) =>
          Provider.of<CartModel.Cart>(context, listen: false)
              .removeItem(productId),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: Padding(
          padding: EdgeInsets.all(1),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(cartItemModel.imageUrl),
            ),
            title: Text(cartItemModel.title),
            subtitle: Row(
              children: <Widget>[
                Chip(
                  label: Text('\$${cartItemModel.price.toString()}'),
                  padding: EdgeInsets.symmetric(vertical: 1, horizontal: 0),
                ),
                SizedBox(width: 10),
                Text(
                  'Total \$${(cartItemModel.price * cartItemModel.quantity).toStringAsFixed(2)}',
                ),
              ],
            ),
            trailing: Chip(
              label: Text('${cartItemModel.quantity}'),
              backgroundColor: Theme.of(context).primaryColorLight,
            ),
          ),
        ),
      ),
    );
  }
}
