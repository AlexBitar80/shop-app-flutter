import 'dart:convert';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shop/exceptions/custom_http_exception.dart';
import 'package:shop/models/product.dart';
import 'package:http/http.dart' as http;

class ProductList with ChangeNotifier {
  final _baseUrl = dotenv.env['BASE_URL']!;
  final List<Product> _items = [];

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

  Future<void> loadProducts() async {
    _items.clear();
    final response = await http.get(Uri.parse('$_baseUrl.json'));
    if (response.body == 'null') return;

    final Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((productId, productData) {
      _items.add(
        Product(
          id: productId,
          name: productData['name'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: productData['isFavorite'],
        ),
      );
    });

    notifyListeners();

    return Future.value();
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse('$_baseUrl.json');
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
    final url = Uri.parse('$_baseUrl/${product.id}.json');

    if (index >= 0) {
      await http.patch(url, body: product.toJson());
      _items[index] = product;
      notifyListeners();
    }

    Future.value();
  }

  Future<void> removeProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);
    final url = Uri.parse('$_baseUrl/${product.id}.json');

    if (index >= 0) {
      final product = _items[index];

      _items.remove(product);
      notifyListeners();

      final response = await http.delete(url);

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();

        throw CustomHttpException(
          'Ocorreu um erro na exclusão do produto.',
          response.statusCode,
        );
      }
    }
  }

  int get itemsCount {
    return _items.length;
  }
}
