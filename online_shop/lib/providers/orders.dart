import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import './cart.dart';
import '../models/http_exception.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });

  OrderItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        amount = json['amount'],
        products = (json['products'] as List<dynamic>)
            .map((productJson) => CartItem.fromJson(productJson))
            .toList(),
        dateTime = DateTime.parse(json['dateTime']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'products': products.map((product) => product.toJson()).toList(),
        'dateTime': DateFormat().format(dateTime),
      };
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders({
    @required this.authToken,
    @required this.userId,
    @required List<OrderItem> orders,
  }) : _orders = orders;

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://flutter-update-67603.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        throw HttpException('Loading placed orders failed.');
      }
      final ordersData = json.decode(response.body) as Map<String, dynamic>;
      if (ordersData == null) {
        return;
      }

      final List<OrderItem> orders = [];
      ordersData.forEach((orderId, orderData) {
        orders.insert(
          0,
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            products: (orderData['products'] as List<dynamic>)
                .map((productData) => CartItem.fromJson(productData))
                .toList(),
            dateTime: DateTime.parse(orderData['dateTime']),
          ),
        );
      });
      _orders = orders;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://flutter-update-67603.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    try {
      final response = await http.post(
        url,
        // body: json.encode(orderItem.toJson()),
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'imageUrl': cp.imageUrl,
                    'price': cp.price,
                    'quantity': cp.quantity,
                  })
              .toList(),
        }),
      );
      if (response.statusCode >= 400) {
        throw HttpException('Could not place the order.');
      }
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timestamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
