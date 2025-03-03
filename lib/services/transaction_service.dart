import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/cartItem.dart';
import '../models/transaction.dart';

class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'transactions';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'transactions.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            items TEXT,
            totalAmount REAL,
            date TEXT,
            type TEXT,
            paymentMethod TEXT
          )
        ''');
      },
    );
  }

  /// Create a new transaction
  Future<int> createTransaction(CustomTransaction transaction) async {
    final db = await database;
    return await db.insert(
      tableName,
      {
        'items': transaction.items.map((item) => item.toJson()).toList().toString(),
        'totalAmount': transaction.totalAmount,
        'date': transaction.date.toIso8601String(),
        'type': transaction.type,
        'paymentMethod': transaction.paymentMethod,
      },
    );
  }

  /// Get all transactions
  Future<List<CustomTransaction>> getAllTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(tableName);
    return result.map((json) {
      return CustomTransaction(
        id: json['id'].toString(),
        items: [],
        totalAmount: json['totalAmount'],
        date: DateTime.parse(json['date']),
        type: json['type'],
        paymentMethod: json['paymentMethod'],
      );
    }).toList();
  }

  /// Get transaction by ID
  Future<CustomTransaction?> getTransactionById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return CustomTransaction(
        id: result.first['id'],
        items: [],
        totalAmount: result.first['totalAmount'],
        date: DateTime.parse(result.first['date']),
        type: result.first['type'],
        paymentMethod: result.first['paymentMethod'],
      );
    }
    return null;
  }
}
