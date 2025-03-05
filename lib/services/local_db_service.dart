import 'package:hosco_shop_2/models/product.dart';
import 'package:hosco_shop_2/models/transaction.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/cart_item.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();
  DatabaseService._constructor();

  Future<Database> get database async {
    if(_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'hosco_shop_db_3.db');
    final database = await openDatabase(
      databasePath,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              category TEXT NOT NULL,
              price REAL NOT NULL,
              stockQuantity INTEGER NOT NULL,
              supplier TEXT NOT NULL,
              receivingDate TEXT NOT NULL,
              imageUrl TEXT NOT NULL,
              description TEXT DEFAULT '',
              isAvailable INTEGER DEFAULT 1,
              discount REAL DEFAULT 0.0
          );
        ''');
        await db.execute('''
          CREATE TABLE transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            totalAmount REAL,
            date TEXT,
            type TEXT,
            paymentMethod TEXT
          );
        ''');
        await db.execute('''
          CREATE TABLE transaction_items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            transactionId INTEGER NOT NULL,
            productId INTEGER,
            quantity INTEGER,
            FOREIGN KEY (transactionId) REFERENCES transactions(id) ON DELETE CASCADE,
            FOREIGN KEY (productId) REFERENCES products(id) ON DELETE CASCADE
          );
        ''');
      },
      version: 1
    );
    return database;
  }

  Future<void> createProduct(Product productData) async {
    final Database db = await database;
    await db.insert(
      'products',
      productData.toJson()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<Product>> getAllProducts() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');

    return maps.map((map) => Product.fromJson(map)).toList();
  }

  Future<void> deleteProduct(int productId) async {
    final db = await database;
    await db.delete(
        'products',
        where: 'id = ?',
        whereArgs: [productId]
    );
  }

  Future<void> updateProduct(Product product) async {
    final db = await database;

    await db.update(
      'products',
      product.toJson(), // Convert product to map
      where: 'id = ?', // Update where id matches
      whereArgs: [product.id], // Use product id as argument
    );
  }

  Future<Product?> getProductById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> result =
    await db.query('products', where: "id = ?", whereArgs: [id]);

    if (result.isNotEmpty) {
      return Product.fromJson(result.first);
    }
    return null; // Return null if no product found
  }

  Future<List<Product>> searchProducts(String query) async {
    final db = await database;
    // print('Search query in model: ${query}');
    List<Map<String, Object?>> searchResult = await db.rawQuery('''
      SELECT * FROM products WHERE id LIKE ? or name LIKE ?
    ''', ["%$query%", "%$query%"]);

    final res = searchResult.map((e) => Product.fromJson(e)).toList();
    // print('Search result: ${res[0]}');
    return res;
  }

  Future<List<Product>> searchProductsPaginated({required String query, required int page, int limit = 5}) async {
    final db = await database;
    int offset = (page - 1) * limit;
    // print('Search query in model: ${query}');
    List<Map<String, Object?>> searchResult = await db.rawQuery('''
      SELECT * FROM products WHERE id LIKE ? or name LIKE ? LIMIT ? OFFSET ?
    ''', ["%$query%", "%$query%", limit, offset]);

    final res = searchResult.map((e) => Product.fromJson(e)).toList();
    // print('Search result: ${res[0]}');
    return res;
  }

  Future<void> insertTransaction(CustomTransaction transaction) async {
    final db = await database;
    int transactionId = await db.insert(
        "transactions",
        transaction.toJson()..remove('id'));
    for (var item in transaction.items) {
      await db.insert(
        "transaction_items",
        {
          "transactionId": transactionId,
          "productId": item.product.id,
          "quantity": item.quantity
        }
      );
    }
  }

  Future<List<CustomTransaction>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> transactionsData = await db.rawQuery('''
      SELECT * FROM transactions ORDER BY date DESC;
    ''');
    List<CustomTransaction> transactions = [];

    for (var transaction in transactionsData) {
      final List<Map<String, dynamic>> cartItemsData = await db.query(
        'transaction_items',
        where: 'transactionId = ?',
        whereArgs: [transaction['id']],
      );

      List<CartItem> cartItems = [];
      for (var cartItem in cartItemsData) {
        var productData = await db.query(
          'products',
          where: 'id = ?',
          whereArgs: [cartItem['productId']],
        );
        Product product = Product.fromJson(productData.first);
        cartItems.add(CartItem.fromJson(cartItem, product));
      }

      transactions.add(CustomTransaction.fromJson(transaction, cartItems));
    }

    return transactions;
  }
}