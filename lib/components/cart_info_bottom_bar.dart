import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/cart.dart';

class CartInfoBottomBar extends StatelessWidget {
  const CartInfoBottomBar({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).primaryColor,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 14,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            const SizedBox(
              width: 10.0,
            ),
            AutoSizeText(
              minFontSize: 18,
              maxFontSize: 22,
              '${cart.itemCount.toString()} itens',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            AutoSizeText(
              minFontSize: 18,
              maxFontSize: 22,
              'Total: R\$ ${cart.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
