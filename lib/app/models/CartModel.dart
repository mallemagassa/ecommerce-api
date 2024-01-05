// import 'package:equatable/equatable.dart';
import 'package:ecommerce/app/models/ProductModel.dart';

class CartModel {
  String id;
  Map<String, dynamic> product;
  int qty;

  CartModel({required this.id, required this.product, this.qty = 0});

  // CartModel copyWith({
  //   required String id,
  //   required ProductModel product,
  //   required int qty,
  // }) =>
  //     CartModel(
  //         id: id,
  //         product: product,
  //         qty: qty);

  // @override
  // List<Object> get props => [id, qty, product];

  void toggleDone() {
    qty++;
  }

  void decreaseDown() {
    qty--;
  }
}