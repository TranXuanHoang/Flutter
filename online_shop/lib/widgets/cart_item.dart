import 'package:flutter/material.dart';
import '../providers/cart.dart' as CartModel;

class CartItem extends StatelessWidget {
  final CartModel.CartItem cartItemModel;

  CartItem(this.cartItemModel);

  @override
  Widget build(BuildContext context) {
    return Card(
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
                // labelStyle: TextStyle(fontSize: 10),
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
    );
  }
}
