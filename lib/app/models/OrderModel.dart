class OrderModel{
  final int? id;
  final String? numOrder;
  final int priceTotal;
  final int quantity;
  final int? userId;
  final int productId;
  final int productPrice;
  final String imageUrl;
  final String productName;
  final String? count;
  final DateTime? createdAt;
                                        
  OrderModel({this.id, this.numOrder, this.count, required this.priceTotal, required this.productPrice, required this.productName, required this.imageUrl, required this.quantity, this.userId, required this.productId, this.createdAt});


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
      productPrice: json['product_price'] as int,
      count: json['count'].toString() as String?,
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
        productPrice = map['product_price'],
        count = map['count'],
        createdAt = map['created_at'];
}