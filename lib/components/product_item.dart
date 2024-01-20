// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(product.imageUrl),
        ),
        title: Text(product.name),
        subtitle: Text(product.description),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                onPressed: () {},
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
