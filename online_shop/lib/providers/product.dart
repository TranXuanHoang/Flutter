import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _toggleIsFavoriteInLocalMemory() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleIsFavorite() async {
    // Toggle the isFavorite in local memory first
    _toggleIsFavoriteInLocalMemory();

    // Update data from remote server using HTTP PATCH request
    final url = 'https://flutter-update-67603.firebaseio.com/products/$id.json';
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );

      // Roll back if the HTTP PATCH response is an error
      if (response.statusCode >= 400) {
        _toggleIsFavoriteInLocalMemory();
      }
    } catch (error) {
      // Also roll back if other errors (i.e. network related errors) occur
      print(error);
      _toggleIsFavoriteInLocalMemory();
    }
  }
}
