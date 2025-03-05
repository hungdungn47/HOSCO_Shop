class Product {
  int id;
  String name;
  String category;
  double price;
  int stockQuantity;
  String supplier;
  DateTime receivingDate;
  String imageUrl;
  String description;
  bool isAvailable;
  double discount;

  Product({
    this.id = 1,
    required this.name,
    required this.category,
    required this.price,
    required this.stockQuantity,
    required this.supplier,
    required this.receivingDate,
    required this.imageUrl,
    this.description = "",
    this.isAvailable = true,
    this.discount = 0.0,
  });

  /// Convert Product to JSON (for API or local storage)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "category": category,
      "price": price,
      "stockQuantity": stockQuantity,
      "supplier": supplier,
      "receivingDate": receivingDate.toIso8601String(),
      "imageUrl": imageUrl,
      "description": description,
      "isAvailable": isAvailable ? 1 : 0,
      "discount": discount,
    };
  }

  /// Create Product from JSON (for API or local storage)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      name: json["name"],
      category: json["category"],
      price: json["price"].toDouble(),
      stockQuantity: json["stockQuantity"],
      supplier: json["supplier"],
      receivingDate: DateTime.parse(json["receivingDate"]),
      imageUrl: json["imageUrl"],
      description: json["description"] ?? "",
      isAvailable: json["isAvailable"] == 1 ? true : false,
      discount: json["discount"]?.toDouble() ?? 0.0,
    );
  }
}
