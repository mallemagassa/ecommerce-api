class ProfilModel{
  final int? id;
  final String? firstname;
  final String? lastname;
  final String image;
  final int? userId;

  ProfilModel({this.id, this.firstname, this.lastname,  required this.image, this.userId});

  factory ProfilModel.fromJson(Map<String, dynamic> json) {
    return ProfilModel(
      id: json['id'] as int?,
      firstname: json['name'] as String?,
      lastname: json['price'] as String?,
      image: json['image'] as String,
      userId: json['user_id']as int?,
    );
  }
}
