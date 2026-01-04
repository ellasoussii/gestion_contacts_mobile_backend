class Contact {
  int? id;
  int userId;
  String name;
  String? surname;
  String phone;
  String? birthdate;
  String? photo;

  Contact({
    this.id,
    required this.userId,
    required this.name,
    this.surname,
    required this.phone,
    this.birthdate,
    this.photo,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "name": name,
      "surname": surname,
      "phone": phone,
      "birthdate": birthdate,
      "photo": photo,
    };
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json["id"],
      userId: json["user_id"],
      name: json["name"],
      surname: json["surname"],
      phone: json["phone"],
      birthdate: json["birthdate"],
      photo: json["photo"],
    );
  }

  Contact copyWith({int? id}) {
    return Contact(
      id: id ?? this.id,
      userId: userId,
      name: name,
      surname: surname,
      phone: phone,
      birthdate: birthdate,
      photo: photo,
    );
  }
}
