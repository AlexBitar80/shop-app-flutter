import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  final _baseUrl = dotenv.env['AUTH_URL']!;
  final _apiKey = dotenv.env['API_KEY']!;

  Future<void> signup(String email, String password) async {
    final url = Uri.parse('$_baseUrl?key=$_apiKey');

    await http.post(
      url,
      body: jsonEncode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
  }
}
