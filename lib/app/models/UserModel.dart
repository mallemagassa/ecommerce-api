class UserModel {
  final int? id;
  final String phone;
  final String? nameCom;
  final String? status;
  final String? address;
  final String? name;
  final String? image;
  final int? conversationId;
  final int? receiverId;
  final bool isSeller;

  UserModel({this.id, required this.phone, this.nameCom, this.address, this.receiverId, this.status, this.name, this.image, this.conversationId, this.isSeller = false});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      phone: json['phone'] as String,
      nameCom: json['nameCom'] as String?,
      status: json['status'] as String?,
      address: json['address'] as String?,
      isSeller: json['isSeller'] as bool,
      receiverId: json['receiver_id'] as int?,
      conversationId: json['conversation_id'] as int?,
    );
  }


  UserModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        phone = map['phone'],
        nameCom = map['nameCom'],
        status = map['status'],
        address = map['address'],
        name = map['name'],
        image = map['image'],
        conversationId = map['conversation_id'],
        receiverId = map['receiver_id'],
        isSeller = map['isSeller'];


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['phone'] = phone;
    data['nameCom'] = nameCom ?? '';
    data['status'] = status ?? '';
    data['address'] = address ?? '';
    data['isSeller'] = isSeller;

    return data;
  }

}
