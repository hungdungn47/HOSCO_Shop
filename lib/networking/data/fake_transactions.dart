import 'package:hosco_shop_2/models/supplier.dart';

import '../../models/cart_item.dart';
import '../../models/transaction.dart';
import '../../models/product.dart';

final List<CustomTransaction> fakeTransactions = [
  CustomTransaction(
    id: 1,
    items: [
      CartItem(
        product: Product(
          id: 1,
          name: "Apple",
          category: "Fruits",
          price: 50000,
          stockQuantity: 100,
          supplier: Supplier(name: "Hung Dung"),
          receivingDate: DateTime.now().subtract(Duration(days: 5)),
          imageUrl: "https://res.cloudinary.com/dan6wlrgq/image/upload/v1741073371/1000000037_tas3sx.jpg",
        ),
        quantity: 3,
      ),
    ],
    totalAmount: 187000,
    date: DateTime.now().subtract(Duration(days: 2)),
    type: "sale",
    paymentMethod: "cash",
  ),
  CustomTransaction(
    id: 2,
    items: [
      CartItem(
        product: Product(
          id: 2,
          name: "Banana",
          category: "Fruits",
          price: 20000,
          stockQuantity: 200,
          supplier: Supplier(name: "Hung Dung"),
          receivingDate: DateTime.now().subtract(Duration(days: 3)),
          imageUrl: "https://res.cloudinary.com/dan6wlrgq/image/upload/v1741073371/1000000037_tas3sx.jpg",
        ),
        quantity: 5,
      ),
    ],
    totalAmount: 100000,
    date: DateTime.now().subtract(Duration(days: 1)),
    type: "sale",
    paymentMethod: "card",
  ),
  CustomTransaction(
    id: 3,
    items: [
      CartItem(
        product: Product(
          id: 3,
          name: "Milk",
          category: "Dairy",
          price: 20000,
          stockQuantity: 50,
          supplier: Supplier(name: "Hung Dung"),
          receivingDate: DateTime.now().subtract(Duration(days: 2)),
          imageUrl: "https://res.cloudinary.com/dan6wlrgq/image/upload/v1741073371/1000000037_tas3sx.jpg",
        ),
        quantity: 1,
      ),
    ],
    totalAmount: 20000,
    date: DateTime.now(),
    type: "sale",
    paymentMethod: "cash",
  ),
  CustomTransaction(
    id: 4,
    items: [
      CartItem(
        product: Product(
          id: 4,
          name: "Bread",
          category: "Bakery",
          price: 35000,
          stockQuantity: 75,
          supplier: Supplier(name: "Hung Dung"),
          receivingDate: DateTime.now().subtract(Duration(days: 1)),
          imageUrl: "https://res.cloudinary.com/dan6wlrgq/image/upload/v1741073371/1000000037_tas3sx.jpg",
        ),
        quantity: 2,
      ),
    ],
    totalAmount: 70000,
    date: DateTime.now().subtract(Duration(days: 3)),
    type: "sale",
    paymentMethod: "cash",
  ),
  CustomTransaction(
    id: 5,
    items: [
      CartItem(
        product: Product(
          id: 5,
          name: "Eggs",
          category: "Poultry",
          price: 10000,
          stockQuantity: 120,
          supplier: Supplier(name: "Hung Dung"),
          receivingDate: DateTime.now().subtract(Duration(days: 4)),
          imageUrl: "https://res.cloudinary.com/dan6wlrgq/image/upload/v1741073371/1000000037_tas3sx.jpg",
        ),
        quantity: 12,
      ),
    ],
    totalAmount: 120000,
    date: DateTime.now().subtract(Duration(days: 5)),
    type: "sale",
    paymentMethod: "card",
  ),
  CustomTransaction(
    id: 6,
    items: [
      CartItem(
        product: Product(
          id: 6,
          name: "Butter",
          category: "Dairy",
          price: 60000,
          stockQuantity: 30,
          supplier: Supplier(name: "Hung Dung"),
          receivingDate: DateTime.now().subtract(Duration(days: 3)),
          imageUrl: "https://res.cloudinary.com/dan6wlrgq/image/upload/v1741073371/1000000037_tas3sx.jpg",
        ),
        quantity: 1,
      ),
    ],
    totalAmount: 60000,
    date: DateTime.now(),
    type: "sale",
    paymentMethod: "cash",
  ),
  CustomTransaction(
    id: 7,
    items: [
      CartItem(
        product: Product(
          id: 7,
          name: "Tomatoes",
          category: "Vegetables",
          price: 30000,
          stockQuantity: 100,
          supplier: Supplier(name: "Hung Dung"),
          receivingDate: DateTime.now().subtract(Duration(days: 2)),
          imageUrl: "https://res.cloudinary.com/dan6wlrgq/image/upload/v1741073371/1000000037_tas3sx.jpg",
        ),
        quantity: 5,
      ),
    ],
    totalAmount: 150000,
    date: DateTime.now().subtract(Duration(days: 6)),
    type: "sale",
    paymentMethod: "cash",
  ),
  CustomTransaction(
    id: 8,
    items: [
      CartItem(
        product: Product(
          id: 8,
          name: "Chicken",
          category: "Meat",
          price: 7.0,
          stockQuantity: 50,
          supplier: Supplier(name: "Hung Dung"),
          receivingDate: DateTime.now().subtract(Duration(days: 1)),
          imageUrl: "https://res.cloudinary.com/dan6wlrgq/image/upload/v1741073371/1000000037_tas3sx.jpg",
        ),
        quantity: 2,
      ),
    ],
    totalAmount: 140000,
    date: DateTime.now().subtract(Duration(days: 7)),
    type: "sale",
    paymentMethod: "cash",
  ),
  CustomTransaction(
    id: 9,
    items: [
      CartItem(
        product: Product(
          id: 9,
          name: "Rice",
          category: "Grains",
          price: 4.0,
          stockQuantity: 200,
          supplier: Supplier(name: "Hung Dung"),
          receivingDate: DateTime.now().subtract(Duration(days: 5)),
          imageUrl: "https://res.cloudinary.com/dan6wlrgq/image/upload/v1741073371/1000000037_tas3sx.jpg",
        ),
        quantity: 3,
      ),
    ],
    totalAmount: 120000,
    date: DateTime.now().subtract(Duration(days: 8)),
    type: "sale",
    paymentMethod: "card",
  ),
  CustomTransaction(
    id: 10,
    items: [
      CartItem(
        product: Product(
          id: 10,
          name: "Coffee",
          category: "Beverages",
          price: 5.0,
          stockQuantity: 100,
          supplier: Supplier(name: "Hung Dung"),
          receivingDate: DateTime.now().subtract(Duration(days: 2)),
          imageUrl: "https://res.cloudinary.com/dan6wlrgq/image/upload/v1741073371/1000000037_tas3sx.jpg",
        ),
        quantity: 1,
      ),
    ],
    totalAmount: 50000,
    date: DateTime.now().subtract(Duration(days: 9)),
    type: "sale",
    paymentMethod: "cash",
  ),
  CustomTransaction(
    id: 11,
    items: [
      CartItem(
        product: Product(
          id: 11,
          name: "Tea",
          category: "Beverages",
          price: 3.5,
          stockQuantity: 80,
          supplier: Supplier(name: "Hung Dung"),
          receivingDate: DateTime.now().subtract(Duration(days: 3)),
          imageUrl: "https://res.cloudinary.com/dan6wlrgq/image/upload/v1741073371/1000000037_tas3sx.jpg",
        ),
        quantity: 2,
      ),
    ],
    totalAmount: 80000,
    date: DateTime.now().subtract(Duration(days: 10)),
    type: "sale",
    paymentMethod: "card",
  ),
  CustomTransaction(
    id: 12,
    items: [
      CartItem(
        product: Product(
          id: 12,
          name: "Cheese",
          category: "Dairy",
          price: 6.0,
          stockQuantity: 40,
          supplier: Supplier(name: "Hung Dung"),
          receivingDate: DateTime.now().subtract(Duration(days: 1)),
          imageUrl: "https://res.cloudinary.com/dan6wlrgq/image/upload/v1741073371/1000000037_tas3sx.jpg",
        ),
        quantity: 1,
      ),
    ],
    totalAmount: 90000,
    date: DateTime.now().subtract(Duration(days: 11)),
    type: "sale",
    paymentMethod: "cash",
  ),
];

// More transactions can be added...

