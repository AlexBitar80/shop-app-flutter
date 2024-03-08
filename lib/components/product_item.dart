import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/alert_shop.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';

import '../exceptions/custom_http_exception.dart';
import '../models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final message = ScaffoldMessenger.of(context);
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(product.imageUrl),
        ),
        title: Text(product.name),
        subtitle: Text(product.description),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.product_form,
                    arguments: product,
                  );
                },
                icon: const Icon(Icons.edit),
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertShopDialog(
                        title: product.name,
                        content: 'Deseja realmente remover o produto?',
                        cancelFunction: () {
                          Navigator.of(ctx).pop();
                        },
                        confirmFunction: () async {
                          try {
                            Navigator.of(ctx).pop();
                            await Provider.of<ProductList>(context,
                                    listen: false)
                                .removeProduct(product);
                          } on CustomHttpException catch (error) {
                            message.showSnackBar(
                              SnackBar(
                                content: Text(
                                  error.toString(),
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  );
                },
                icon: const Icon(Icons.delete),
                color: Theme.of(context)
                    .copyWith(
                      iconTheme: const IconThemeData(
                        color: Colors.red,
                      ),
                    )
                    .iconTheme
                    .color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
