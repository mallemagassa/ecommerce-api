import 'package:get/get.dart';

class ProductModel{
  final int? id;
  final String name;
  final int price;
  final String describes;
  final String image;
  final int quantity;
  final int? userId;
  var isSelected = false.obs;

  ProductModel({
    required this.id, 
    required this.name, 
    required this.price, 
    required this.describes, 
    required this.image, 
    required this.isSelected,
    required this.quantity,
    this.userId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      price: json['price'] as int,
      describes: json['describes'] as String,
      image: json['image'] as String,
      isSelected: false.obs,
      quantity: json['quantity'] as int,
      userId: json['user_id'] as int?,
    );
  }


  ProductModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        price = map['price'],
        describes = map['describes'],
        image = map['image'],
        isSelected = false.obs,
        quantity = map['quantity'],
        userId = map['user_id'];
}