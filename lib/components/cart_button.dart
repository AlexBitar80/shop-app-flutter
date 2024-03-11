import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../models/order_list.dart';

class CartButton extends StatefulWidget {
  const CartButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator.adaptive()
        : TextButton(
            onPressed: widget.cart.itemCount == 0
                ? null
                : () async {
                    setState(() => _isLoading = true);
                    await Provider.of<OrderList>(
                      context,
                      listen: false,
                    ).addOrder(widget.cart);

                    widget.cart.clear();

                    setState(() => _isLoading = false);
                  },
            child: const Text("COMPRAR"),
          );
  }
}
