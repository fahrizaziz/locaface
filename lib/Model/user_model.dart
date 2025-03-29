class UserModel {
  int? id;
  String? name, email, role;
  dynamic phone, position, department, faceEmbedding, imageUrl;
  UserModel({
    this.id,
    this.department,
    this.email,
    this.faceEmbedding,
    this.imageUrl,
    this.name,
    this.phone,
    this.position,
    this.role,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      department: json['department'],
      email: json['email'],
      faceEmbedding: json['face_embedding'],
      imageUrl: json['image_url'],
      name: json['name'],
      phone: json['phone'],
      position: json['position'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['department'] = department;
    data['email'] = email;
    data['face_embedding'] = faceEmbedding;
    data['image_url'] = imageUrl;
    data['name'] = name;
    data['phone'] = phone;
    data['position'] = position;
    data['role'] = role;
    return data;
  }
}
