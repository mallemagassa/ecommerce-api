import 'package:ecommerce/app/models/CartModel.dart';
import 'package:ecommerce/app/models/ProductModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CartController extends GetxController {
  static CartController instance = Get.find();
  //final cart = CartModel().obs;

  var cartItems = <CartModel>[].obs;
  int get count => cartItems.length;
  var count2 = 0.0;
  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + item.product['id'] * item.qty);

  void addToCart(List<Map<String, dynamic>> product) {
    try {
      product.forEach((product) {
        if (isAlredyAdded(product)) {
          Get.snackbar("Vérifiez votre panier.", "${product['name']} Est déjà ajouté.",
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 1));
          //print('udah di added');
        } else {
          var uuid = Uuid();
          String itemId = uuid.v4();
          cartItems.add(CartModel(
            id: itemId,
            product: product,
            qty: 1,
          ));
          getTotalsMount();
          update();
        }
      });
    } catch (e) {}
  }

  bool isAlredyAdded(Map<String, dynamic> product) =>
      cartItems.where((item) => item.product['id'] == product['id']).isNotEmpty;

  void decreasqty({
    required CartModel cart,
  }) {
    if (cart.qty == 1) {
      removeCart(cart);

      Get.snackbar("Réussir", "L'élément a été supprimé avec succès",
          duration: Duration(seconds: 1));
    } else {
      int index = cartItems.indexWhere((e) => e.id == cart.id);
      cartItems[index].qty = --cart.qty;
      getTotalsMount();
      update();
    }
  }

  void increasQty(CartModel cart) {
    if (cart.qty >= 1) {
      cart.toggleDone();
      getTotalsMount();
      update();
    }
  }

  void removeCart(CartModel cart) {
    cartItems.remove(cart);
    getTotalsMount();
    update();
  }

  void getTotalsMount() {
    double totalamount =
        cartItems.fold(0, (sum, item) => sum + item.product['price'] * item.qty);
    count2 = totalamount;
  }
}
