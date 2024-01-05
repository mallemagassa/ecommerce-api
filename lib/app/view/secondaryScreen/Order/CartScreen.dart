import 'package:ecommerce/app/controllers/CartController.dart';
import 'package:ecommerce/app/models/OrderModel.dart';
import 'package:ecommerce/contactConfig/ContactConfig.dart';
import 'package:ecommerce/data/response/serviceApi/OrderApi.dart';
import 'package:ecommerce/utils/CartArd.dart';
import 'package:ecommerce/utils/DefaultTitle.dart';
import 'package:ecommerce/utils/SizeHeigth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});
  final CartController cartController = Get.put(CartController());
  final argumentData = Get.arguments;
  final box = GetStorage();
  double priceTotal = 0;
  int qtyProduct = 1;
  @override
  Widget build(BuildContext context) {
    // print('ellllle  '+argumentData['productsCart'].toString());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 5,
        title: const Text('Bienvenue à votre Panier d\'Achat',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        
        ),
        //const DeviderPage(),//NamePageSecondary(title: "Produits "),
      ),
      body: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Sized().sizedHeigth(20),
            Center(
              child: DefautText().defautTitle2(
                "Vous pouvez modifier les quantités des produits dont vous souhaitez commander",
                textAlign: TextAlign.center,
                size: 14,
              ),
            ),
      
            Expanded(
              child: Container(
                  margin: EdgeInsets.fromLTRB(24, 30, 24, 0),
                  child: Stack(
                    children: [
                      ListView(
                        children: [
                          GetBuilder<CartController>(builder: (controller) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                  children: cartController.cartItems
                                      .map((e) => Padding(
                                          padding: const EdgeInsets.only(bottom: 10),
                                          child: CartCArd(
                                            function1: () {
                                              cartController.increasQty(e);
                                              qtyProduct = e.qty;
                                              print('Price total is ${qtyProduct}');
                                            },
                                            function2: () {
                                              cartController.decreasqty(cart: e);
                                              qtyProduct = e.qty;
                                             
                                            },
                                            product: e,
                                          )))
                                      .toList()),
                            );
                          }),
                          SizedBox(
                            height: 150,
                          )
                        ],
                      ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.only(top: 5),
                      color: Colors.white,
                      width: double.infinity,
                      height: 130,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total', style: TextStyle(fontSize: 18)),
                              GetBuilder<CartController>(builder: (controller) {
                                priceTotal = controller.count2;
                                //print('Price total is ${controller.count2}');
                                return Text(
                                  '${controller.count2}',
                                  style: TextStyle(fontSize: 20),
                                );
                              }),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          ZoomTapAnimation(
                            child: GestureDetector(
                              onTap: (){
                                Get.offAndToNamed("/chatScreen", arguments: <String, dynamic>{
                                  'products': argumentData['productsCart'],//cartController.cartItems,
                                  'id': argumentData['userId'],
                                  'name': argumentData['userName'],
                                  'url': argumentData['userUrl'],
                                  'phone': argumentData['phone'],
                                });
                               
                                cartController.cartItems.forEach((element) async {
                                  String imageUrl = element.product['image'];
                                  final map = {
                                    'priceTotal':priceTotal.toInt(),
                                    'quantity':qtyProduct,
                                    'product_id':element.product['id'],
                                    'imageUrl':imageUrl.replaceAll('/', ''),
                                    'product_name':element.product['name'],
                                  };
                                  
                                  print('ellement est name ${element.product['name']}');
                                  print('qtyProduct is : $qtyProduct et $priceTotal');

                                  OrderModel orders = OrderModel.fromMap(map);

                                  await OrderApi().createOrderModel(orders);
                                 // await ContactConfig().loadAndgetMyOders();
                                },);

                               //cartController.cartItems.clear();
                              },
                              child: Container(
                                height: 64,
                                width: double.infinity,
                                decoration:const  BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                ),
                                child: const Center(
                                  child: Text(
                                    ' Valider votre Commande',
                                    style:
                                        TextStyle(fontSize: 24, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            )
      ])
    );
  }
}