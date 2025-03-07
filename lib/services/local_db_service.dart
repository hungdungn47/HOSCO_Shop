import 'package:hosco_shop_2/models/customer.dart';
import 'package:hosco_shop_2/models/product.dart';
import 'package:hosco_shop_2/models/transaction.dart';
import 'package:hosco_shop_2/networking/data/default_model.dart';
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
        // await db.execute('''
        //   CREATE TABLE customers (
        //     id INTEGER PRIMARY KEY AUTOINCREMENT,
        //     name TEXT NOT NULL,
        //     phone TEXT,
        //     email TEXT,
        //     address TEXT,
        //     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        //   );
        // ''');
        // await db.execute('''
        //   CREATE TABLE suppliers (
        //     id INTEGER PRIMARY KEY AUTOINCREMENT,
        //     name TEXT NOT NULL,
        //     phone TEXT,
        //     email TEXT,
        //     address TEXT,
        //     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        //   );
        // ''');
        // await db.execute('''
        //   ALTER TABLE products ADD COLUMN supplierId INTEGER REFERENCES suppliers(id);
        // ''');
        // await db.execute('''
        //   ALTER TABLE transactions ADD COLUMN customerId INTEGER REFERENCES customers(id);
        // ''');
      },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) { // Make sure we only upgrade if needed
            await db.execute('''
          CREATE TABLE customers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            phone TEXT,
            email TEXT,
            address TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          );
        ''');
            await db.execute('''
          CREATE TABLE suppliers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            phone TEXT,
            email TEXT,
            address TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          );
        ''');
            await db.execute('''
          ALTER TABLE products ADD COLUMN supplierId INTEGER REFERENCES suppliers(id);
        ''');
            await db.execute('''
          ALTER TABLE transactions ADD COLUMN customerId INTEGER REFERENCES customers(id);
        ''');
          }
        },
      version: 2
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

        if (productData.isEmpty) {
          // If product is deleted, skip this cart item or handle it differently
          print("Warning: Product with ID ${cartItem['productId']} not found.");
          continue; // Skip the item to avoid errors
        }

        Product product = Product.fromJson(productData.first);
        cartItems.add(CartItem.fromJson(cartItem, product));
      }

      transactions.add(CustomTransaction.fromJson(transaction, cartItems, defaultCustomer));
    }

    return transactions;
  }

  Future<List<Map<String, dynamic>>> getTransactionsValue() async {
    final db = await database;
    final List<Map<String, dynamic>> transactionsData = await db.rawQuery('''
      SELECT date, totalAmount, paymentMethod FROM transactions ORDER BY date DESC;
    ''');
    return transactionsData;
  }
  Future<List<String>> getAllCategories() async {
    final db = await database;
    List<Map<String, Object?>> categoriesMap = await db.rawQuery("SELECT DISTINCT category FROM products");
    // categoriesMap.forEach((entry) {
    //   print(entry.entries);
    // });
    return categoriesMap.map((mapEntry) => mapEntry['category'] as String).toList();
  }
  Future<List<Map<String, dynamic>>> getBestSellingProducts({int limit = 10}) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT p.id, p.name, p.category, p.price, p.imageUrl, 
             SUM(ti.quantity) AS totalSold
      FROM transaction_items ti
      JOIN products p ON ti.productId = p.id
      GROUP BY p.id
      ORDER BY totalSold DESC
      LIMIT ?
    ''', [limit]);
  }

  Future<int> addCustomer(Customer customer) async {
    //String name, String phone, String email, String address
    final db = await database;
    return await db.insert('customers', {
      'name': customer.name,
      'phone': customer.phone,
      'email': customer.email,
      'address': customer.address,
    });
  }

  Future<int> addSupplier(String name, String phone, String email, String address) async {
    final db = await database;
    return await db.insert('suppliers', {
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
    });
  }

  Future<List<Map<String, dynamic>>> getAllCustomers() async {
    final db = await database;
    return await db.query('customers');
  }

  Future<List<Map<String, dynamic>>> getAllSuppliers() async {
    final db = await database;
    return await db.query('suppliers');
  }

  Future<int> updateCustomer(Customer customer) async {
    final db = await database;
    return await db.update("customers", customer.toMap(), where: "id = ?", whereArgs: [customer.id]);
  }

  Future<int> deleteCustomer(int id) async {
    final db = await database;
    return await db.delete("customers", where: "id = ?", whereArgs: [id]);
  }
}