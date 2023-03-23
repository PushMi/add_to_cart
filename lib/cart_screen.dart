import 'package:add_product_to_cart/cart_model.dart';
import 'package:add_product_to_cart/cart_provider.dart';
import 'package:add_product_to_cart/database.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Added Product lists'),
        centerTitle: true,
        actions: [
          Padding(
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
          // SizedBox(width: 20.0),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: cart.getData(),
              builder: (context, AsyncSnapshot<List<Cart>> snapshot){
              if(snapshot.hasData){
                return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.length,
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
                                        snapshot.data![index].image.toString(),
                                        height: 100,
                                        width: 100,
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot.data![index].productName.toString(),
                                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                                                ),
                                                InkWell(
                                                  onTap: (){
                                                    dbHelper.delete(snapshot.data![index].id!);
                                                    cart.removeCounter();
                                                    cart.removeTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));

                                                  },
                                                  child: const Icon(Icons.delete),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(width: 5),
                                            Text(snapshot.data![index].productPrice.toString() + r'₹' + snapshot.data![index].unitTag.toString(),
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                                            ),
                                            const SizedBox(height: 5,),

                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 3),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: (){

                                          },
                                          child: Container(
                                            height: 35,
                                            width: 70,
                                            decoration: const BoxDecoration(
                                                color: Colors.teal
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: (){
                                                      int quantity = snapshot.data![index].quantity!;
                                                      int price = snapshot.data![index].initialPrice!;
                                                      quantity--;
                                                      int? newPrice = price * quantity;

                                                      if (quantity > 0) {
                                                        dbHelper.updateQuantity(
                                                          Cart(
                                                            id: snapshot.data![index].id,
                                                            productId: snapshot.data![index].id!.toString(),
                                                            productName: snapshot.data![index].productName!,
                                                            initialPrice: snapshot.data![index].initialPrice!,
                                                            productPrice: newPrice,
                                                            quantity: quantity,
                                                            unitTag: snapshot.data![index].unitTag.toString(),
                                                            image: snapshot.data![index].image.toString(),
                                                          ),
                                                        ).then((value){
                                                          newPrice = 0;
                                                          quantity = 0;
                                                          cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                        }).onError((error, stackTrace){
                                                          print(error.toString());
                                                        });
                                                      }
                                                    },
                                                    child: const Icon(Icons.remove, color: Colors.white),
                                                  ),
                                                  Text(
                                                    snapshot.data![index].quantity.toString(),
                                                    style: const TextStyle(color: Colors.white),
                                                  ),
                                                  InkWell(
                                                    onTap: (){
                                                      int quantity = snapshot.data![index].quantity!;
                                                      int price = snapshot.data![index].initialPrice!;
                                                      quantity++;
                                                      int? newPrice = price * quantity;
                                                      
                                                      dbHelper.updateQuantity(
                                                          Cart(
                                                              id: snapshot.data![index].id,
                                                              productId: snapshot.data![index].id!.toString(),
                                                              productName: snapshot.data![index].productName!,
                                                              initialPrice: snapshot.data![index].initialPrice!,
                                                              productPrice: newPrice,
                                                              quantity: quantity,
                                                              unitTag: snapshot.data![index].unitTag.toString(),
                                                              image: snapshot.data![index].image.toString(),
                                                          ),
                                                      ).then((value){
                                                        newPrice = 0;
                                                        quantity = 0;
                                                        cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                      }).onError((error, stackTrace){
                                                        print(error.toString());
                                                      });
                                                    },
                                                    child: const Icon(Icons.add, color: Colors.white),),
                                                ],
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
                );
              }
              return Text('');
          }),
          Consumer<CartProvider>(builder: (context, value, child){
            return Visibility(
              visible: value.getTotalPrice().toStringAsFixed(2) == '0.00' ? false : true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ReusableWidget(title: 'Sub Total => ', value: value.getTotalPrice().toStringAsFixed(2) + r'₹'),
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(title, style: Theme.of(context).textTheme.subtitle2,),
          Text(value.toString(), style: Theme.of(context).textTheme.subtitle2,)
        ],
      ),
    );
  }
}
