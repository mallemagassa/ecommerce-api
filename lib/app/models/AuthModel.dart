class AuthModel {

   final int? id;
  final String phone;
  final String? nameCom;
  final String? status;
  final String? address;
  final bool isSeller;

  AuthModel({this.id, required this.phone, this.nameCom, this.address, this.status, this.isSeller = false});

   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = phone;
    data['nameCom'] = nameCom ?? '';
    data['status'] = status ?? '';
    data['address'] = address ?? '';
    data['isSeller'] = isSeller;

    return data;
  }
  
}