import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/custom_http_exception.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/product.dart';

import '../utils/app_routes.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context);
    final message = ScaffoldMessenger.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Colors.grey[200],
        child: GridTile(
          header: Row(
            children: [
              Consumer<Product>(
                builder: (ctx, product, _) {
                  return IconButton(
                    onPressed: () async {
                      try {
                        await product.toggleFavorite();
                      } on CustomHttpException catch (error) {
                        message.showSnackBar(
                          SnackBar(
                            content: Text(error.toString()),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  );
                },
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  cart.addItem(product);
                },
                icon: const Icon(Icons.shopping_cart),
                color: Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            title: Text(
              product.name,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.product_detail,
                arguments: product,
              );
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
