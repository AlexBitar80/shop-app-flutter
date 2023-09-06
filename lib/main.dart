import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/products_overview_page.dart';
import 'package:shop/utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductList(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.purple[400],
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.deepOrange,
          ),
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewPage(),
        routes: {
          AppRoutes.product_detail: (ctx) => const ProductDetailPage(),
        },
      ),
    );
  }
}
