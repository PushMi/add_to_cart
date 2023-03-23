import 'package:add_product_to_cart/cart_provider.dart';
import 'package:add_product_to_cart/product_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CartProvider(),
      child: Builder(builder: (BuildContext context){
        return MaterialApp(
          title: 'Your Cart',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.pink,
          ),
          home: const ProductListScreen(),
        );
      }),
    );
  }
}

