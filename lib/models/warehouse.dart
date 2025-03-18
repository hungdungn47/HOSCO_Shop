class Warehouse {
  String id;
  String name;
  String location;

  Warehouse({required this.id, required this.name, required this.location});

  // Convert Warehouse object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
    };
  }

  // Create Warehouse object from JSON
  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
    );
  }
}
