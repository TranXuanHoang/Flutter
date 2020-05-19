import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            child: ListTile(
              key: ValueKey(widget.order.id),
              title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
              subtitle: Text(
                DateFormat('MMM dd, yyyy  HH:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            color: _expanded ? Color.fromRGBO(255, 230, 204, 1) : Colors.white10,
          ),
          if (_expanded)
            Container(
              // margin: EdgeInsets.all(15),
              height: min(120, widget.order.products.length * 75.0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  var product = widget.order.products[index];
                  return ListTile(
                    key: ValueKey(product.id),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(product.imageUrl),
                    ),
                    title: Text(product.title),
                    subtitle: Text('\$${product.price}'),
                    trailing: Chip(
                      label: Text(
                        '${product.quantity}',
                      ),
                      backgroundColor: Theme.of(context).primaryColorLight,
                    ),
                  );
                },
                itemCount: widget.order.products.length,
              ),
            ),
        ],
      ),
    );
  }
}
