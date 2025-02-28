import 'package:hosco_shop_2/models/product.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
    final databasePath = join(databaseDirPath, 'hosco_shop_db.db');
    final database = await openDatabase(
      databasePath,
      onCreate: (db, version) {
        db.execute('''
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
          )
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
}