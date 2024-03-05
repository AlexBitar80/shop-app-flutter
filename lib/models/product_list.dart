import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';
import 'package:http/http.dart' as http;

class ProductList with ChangeNotifier {
  final _baseUrl = 'https://shop-flutter-669bf-default-rtdb.firebaseio.com';
  final List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];
  List<Product> get favoriteItems => _items
      .where(
        (product) => product.isFavorite,
      )
      .toList();

  Future<void> saveProduct({required Map<String, Object> data}) async {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse('$_baseUrl/products.json');
    final response = await http.post(
      url,
      body: product.toJson(),
    );

    final id = jsonDecode(response.body)['name'];

    _items.add(Product(
      id: id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      isFavorite: product.isFavorite,
    ));

    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    final index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }

    Future.value();
  }

  void removeProduct(Product product) {
    _items.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }

  int get itemsCount {
    return _items.length;
  }
}
