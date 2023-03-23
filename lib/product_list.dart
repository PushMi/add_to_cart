import 'package:add_product_to_cart/cart_model.dart';
import 'package:add_product_to_cart/cart_provider.dart';
import 'package:add_product_to_cart/cart_screen.dart';
import 'package:add_product_to_cart/database.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {

  DatabaseHelper dbHelper = DatabaseHelper();
  List<String> productName = ['Mango', 'Apple', 'Orange', 'Banana', 'Cherry', 'Peach', 'Grapes', 'Fruit Basket'];
  List<String> productUnit = ['(Kg)', '(Kg)', '(Dozen)', '(Dozen)', '(Kg)', '(Kg)', '(Kg)', '(Kg)'];
  List<int> productPrice = [10, 20, 30, 40, 50, 60, 70, 100];
  List<String> productImage = [
    'images/mango.jpg',
    'images/apple.jpg',
    'images/orange.jpg',
    'images/banana.jpg',
    'images/cherries.jpg',
    'images/peach.jpg',
    'images/grapes.jpg',
    'images/mixed_fruit.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value, child){
                    return Text(value.getCounter().toString(), style: const TextStyle(color: Colors.white));
                  },
                ),
                badgeAnimation: const BadgeAnimation.slide(
                  animationDuration: Duration(seconds: 3),
                ),
                badgeStyle: const BadgeStyle(badgeColor: Colors.green),
                child: const Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
          // SizedBox(width: 20.0),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: productImage.length,
                  itemBuilder: (context, index){
                return Card(
                  color: Colors.pinkAccent.withOpacity(0.5),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.asset(
                              productImage[index].toString(),
                              height: 100,
                              width: 100,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(productName[index].toString(),
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(productPrice[index].toString() + r'₹' + productUnit[index].toString(),
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                                  ),
                                  const SizedBox(height: 5,),

                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: (){
                                  dbHelper.insert(
                                    Cart(
                                        id: index, 
                                        productId: index.toString(), 
                                        productName: productName[index].toString(), 
                                        initialPrice: productPrice[index], 
                                        productPrice: productPrice[index], 
                                        quantity: 1, 
                                        unitTag: productUnit[index].toString(), 
                                        image: productImage[index].toString())
                                  ).then((value){
                                    print('Product is added to cart :)');
                                    cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                    cart.addCounter();
                                  }).onError((error, stackTrace){
                                    print(error.toString());
                                  });
                                },
                                child: Container(
                                  height: 35,
                                  width: 80,
                                  decoration: const BoxDecoration(
                                      color: Colors.green
                                  ),
                                  child: const Center(
                                      child: Text(
                                        'Add to cart',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ),
        ],
      ),
    );
  }
}



