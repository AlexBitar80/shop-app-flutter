// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constantes {
  static var product_base_url = dotenv.env['PRODUCT_BASE_URL']!;
  static var order_base_url = dotenv.env['ORDER_BASE_URL']!;
}
