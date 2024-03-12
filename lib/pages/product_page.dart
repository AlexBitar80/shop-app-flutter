import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';

import '../components/app_drawer.dart';
import '../components/product_item.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({
    super.key,
  });

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<ProductList>(
      context,
      listen: false,
    ).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final ProductList products = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Produtos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.product_form);
            },
          ),
        ],
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: products.itemsCount,
            itemBuilder: (ctx, i) => ProductItem(
              product: products.items[i],
            ),
          ),
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
