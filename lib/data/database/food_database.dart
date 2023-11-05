import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:doni_pizza/data/models/food_model.dart';
import 'package:doni_pizza/data/models/order_item.dart';

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
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        imageUrl TEXT,
        price REAL,
        category TEXT,
        count INTEGER DEFAULT 1
      )
    ''');
  }

  Future<void> insertFood(FoodItem foodItem) async {
    try {
      final db = await database;

      final existingProducts =
          await db.query('food_table', where: 'id = ?', whereArgs: [foodItem.id]);

      if (existingProducts.isNotEmpty) {
        final existingProduct = existingProducts.first;
        final existingCount = existingProduct['count'] as int?;
        final updatedCount = (existingCount ?? 0) + 1;
        await db.update(
          'food_table',
          {'count': updatedCount},
          where: 'id = ?',
          whereArgs: [foodItem.id],
        );
      } else {
        await db.insert('food_table', foodItem.toJson());
      }
    } catch (e) {
      print("Error insert: $e");
    }
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
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('food_table');
      return List.generate(maps.length, (index) {
        final foodItem = FoodItem.fromJson(maps[index]);
        final quantity = maps[index]['count'] as int;
        return OrderItem(food: foodItem, quantity: quantity);
      });
    } catch (e) {
      print("Error: $e");
      throw Exception('Error fetching all food items: $e');
    }
  }

  Future<void> updateFoodByCount(String id, int newCount) async {
    final db = await database;
    await db.update(
      'food_table',
      {'count': newCount},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteFood(String id) async {
    final db = await database;
    await db.delete(
      'food_table',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    final db = await database;
    await db.delete('food_table');
  }
}
