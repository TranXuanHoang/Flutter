import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authToken;
  final String userId;

  /// * [authToken] is the authentication token obtained after successfully
  /// authenticating (will be provided by the [Auth]).
  /// * [userId] is the unique id assigned to each user after succesfully registering
  /// a user account with this app. The [usreId] is loaded and save locally after logging in.
  /// * [items] is a list of [Product]s previously saved in the [_items] of this [Products].
  /// At the initial step, this [items] should be set as an empty list. Then after
  /// successfully logging in, it will be set to a list of products fetched from
  /// the remote server. That list of fetched products will be passed to
  /// this constructor whenever the [ChangeNotifierProxyProvider] calls its update function.
  Products({
    @required this.authToken,
    @required this.userId,
    @required List<Product> items,
  }) : _items = items;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere(
      (product) => product.id == id,
      orElse: () => null,
    );
  }

  Future<void> fetchAndSetProducts() async {
    var url =
        'https://flutter-update-67603.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        throw HttpException('Loading products failed.');
      }
      final productsData = json.decode(response.body) as Map<String, dynamic>;
      if (productsData == null) {
        return;
      }

      url =
          'https://flutter-update-67603.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      if (favoriteResponse.statusCode >= 400) {
        throw HttpException('Loading favorite failed.');
      }
      final favoriteData = json.decode(favoriteResponse.body);

      List<Product> products = [];
      productsData.forEach((productId, productData) {
        products.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite:
              favoriteData == null ? false : favoriteData[productId] ?? false,
        ));
      });
      _items.clear();
      _items.addAll(products);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProduct(Product item) async {
    final url =
        'https://flutter-update-67603.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': item.title,
          'description': item.description,
          'price': item.price,
          'imageUrl': item.imageUrl,
          // No need to add isFavorite
        }),
      );

      if (response.statusCode >= 400) {
        throw HttpException('Adding new product failed.');
      }
      _items.add(
        Product(
          id: json.decode(response.body)['name'],
          title: item.title,
          description: item.description,
          price: item.price,
          imageUrl: item.imageUrl,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String productId, Product item) async {
    final existingIndex = _items.indexWhere((item) => item.id == productId);
    if (existingIndex >= 0) {
      try {
        final url =
            'https://flutter-update-67603.firebaseio.com/products/$productId.json?auth=$authToken';
        final response = await http.patch(
          url,
          body: json.encode({
            'title': item.title,
            'description': item.description,
            'price': item.price,
            'imageUrl': item.imageUrl,
            // No need to update isFavorite
          }),
        );

        if (response.statusCode >= 400) {
          throw HttpException('Could not update product.');
        }
        _items[existingIndex] = item;
        notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    }
  }

  /// Optimistically deletes the product first, then send HTTP DELETE
  /// to delete its data from the remote web server's database.
  /// If the HTTP DELETE failed, then rolls back by inserting the removed
  /// product into the original list of product at the original index.
  Future<void> deleteProduct(String productId) async {
    final existingProductIndex =
        _items.indexWhere((item) => item.id == productId);
    var existingProduct = _items.removeAt(existingProductIndex);
    notifyListeners();

    var url =
        'https://flutter-update-67603.firebaseio.com/products/$productId.json?auth=$authToken';
    final response = await http.delete(url);

    url =
        'https://flutter-update-67603.firebaseio.com/userFavorites/$userId/$productId.json?auth=$authToken';
    final favoriteResponse = await http.delete(url);

    if (response.statusCode >= 400 || favoriteResponse.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();

      if (response.statusCode >= 400 && favoriteResponse.statusCode < 400) {
        throw HttpException('Deleting product failed!');
      }
      if (response.statusCode < 400 && favoriteResponse.statusCode >= 400) {
        throw HttpException('Deleting favorite failed.');
      }
      if (response.statusCode >= 400 && favoriteResponse.statusCode >= 400) {
        throw HttpException(
            'Both deleting product and deleting favorite failed.');
      }
    }

    // Free not-used object
    existingProduct = null;
  }
}
