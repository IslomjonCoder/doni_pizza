import 'package:doni_pizza/data/models/food_model.dart';
import 'package:doni_pizza/data/models/order_item.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._privateConstructor();
  static Database? _database;

  LocalDatabase._privateConstructor();

  factory LocalDatabase() {
    return instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'food_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS food_table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        imagePath TEXT,
        price REAL,
        count INTEGER DEFAULT 1
        
      )
    ''');
  }

  Future<int> insertFood(FoodItem foodItem) async {
    final db = await database;

    final existingProducts =
        await db.query('food_table', where: 'name = ?', whereArgs: [foodItem.name]);

    if (existingProducts.isNotEmpty) {
      final existingProduct = existingProducts.first;
      final existingCount = existingProduct['count'] as int?;
      final updatedCount = (existingCount ?? 0) + 1;
      await db.update(
        'food_table',
        {'count': updatedCount},
        where: 'name = ?',
        whereArgs: [foodItem.name],
      );
    } else {
      await db.insert('food_table', foodItem.toJson());
    }
    return 0;
  }

  Future<double> calculateTotalCost() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('food_table');
    double totalCost = 0.0;

    for (final map in maps) {
      final foodItem = FoodItem.fromJson(map);
      totalCost += foodItem.price;
    }

    return totalCost;
  }

  Future<List<OrderItem>> fetchAllFoodItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('food_table');
    return List.generate(maps.length, (index) {
      return OrderItem.fromJson(maps[index]);
    });
  }

  Future<void> updateFoodByCount(String description, int newCount) async {
    final db = await database;
    await db.update(
      'food_table',
      {'count': newCount},
      where: 'description = ?',
      whereArgs: [description],
    );
  }

  Future<void> deleteFood(String description) async {
    final db = await database;
    await db.delete(
      'food_table',
      where: 'description = ?',
      whereArgs: [description],
    );
  }

  Future<void> deleteAll() async {
    final db = await database;
    await db.delete('food_table');
  }
}
