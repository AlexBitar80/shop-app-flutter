import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/order_list.dart';

import '../components/app_drawer.dart';
import '../components/order_widget.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({
    super.key,
  });

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<OrderList>(
      context,
      listen: false,
    ).loadOrders().then(
      (_) {
        setState(() {
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : ListView.builder(
              itemCount: orders.itemsCount,
              itemBuilder: (ctx, i) {
                return OrderWidget(
                  order: orders.items[i],
                );
              },
            ),
      drawer: const AppDrawer(),
    );
  }
}
