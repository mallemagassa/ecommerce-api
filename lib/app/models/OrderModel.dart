class OrderModel{
  final int? id;
  final String? numOrder;
  final int priceTotal;
  final int quantity;
  final int? userId;
  final int productId;
  final String imageUrl;
  final String productName;
  final DateTime? createdAt;
                                        
  OrderModel({this.id, this.numOrder, required this.priceTotal, required this.productName, required this.imageUrl, required this.quantity, this.userId, required this.productId, this.createdAt});


   factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int?,
      numOrder: json['numOrder'] as String?,
      priceTotal: json['priceTotal'] as int,
      quantity: json['quantity'] as int,
      userId: json['user_id'] as int?,
      productId: json['product_id'] as int,
      imageUrl: json['imageUrl'] as String,
      productName: json['product_name'] as String,
      createdAt: DateTime.tryParse(json['created_at']),
    );
  }

  OrderModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        numOrder = map['numOrder'],
        priceTotal = map['priceTotal'],
        quantity = map['quantity'],
        userId = map['user_id'],
        productId = map['product_id'],
        imageUrl = map['imageUrl'],
        productName = map['product_name'],
        createdAt = map['created_at'];
}