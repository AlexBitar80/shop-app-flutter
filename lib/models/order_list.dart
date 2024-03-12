import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/order.dart';
import 'package:http/http.dart' as http;

class OrderList with ChangeNotifier {
  final String _baseUrl = dotenv.env['ORDER_BASE_URL']!;
  final List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    _items.clear();
    final response = await http.get(Uri.parse('$_baseUrl.json'));
    if (response.body == 'null') return;

    final Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((orderId, orderData) {
      _items.add(
        Order(
          id: orderId,
          total: orderData['total'],
          date: DateTime.parse(orderData['date']),
          products: (orderData['products'] as List<dynamic>).map((item) {
            return CartItem(
              id: item['id'],
              productId: item['productId'],
              name: item['title'],
              quantity: item['quantity'],
              price: item['price'],
            );
          }).toList(),
        ),
      );
    });

    notifyListeners();
  }

  Future<void> addOrder(Cart cart) async {
    final url = Uri.parse('$_baseUrl.json');
    final date = DateTime.now();

    final response = await http.post(
      url,
      body: jsonEncode(
        {
          'total': cart.totalAmount,
          'date': DateTime.now().toIso8601String(),
          'products': cart.items.values
              .map(
                (cartProduct) => {
                  'id': cartProduct.id,
                  'productId': cartProduct.productId,
                  'title': cartProduct.name,
                  'quantity': cartProduct.quantity,
                  'price': cartProduct.price,
                },
              )
              .toList(),
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _items.insert(
      0,
      Order(
        id: id,
        total: cart.totalAmount,
        products: cart.items.values.toList(),
        date: date,
      ),
    );

    notifyListeners();
  }
}
