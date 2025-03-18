class Partner {
  int? id;
  String name;
  String phone;
  String? email;
  String address;
  String role;

  Partner({
    this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.address,
    required this.role,
  });

  // Convert Partner object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'role': role,
    };
  }

  // Create Partner object from JSON
  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      role: json['role'],
    );
  }
}
