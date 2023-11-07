import 'package:doni_pizza/data/models/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String userModelBoxName = 'userModelBox';
  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
  }

  static Future<void> openBoxes() async {
    await Hive.openBox<UserModel>(userModelBoxName);
  }

  static Future<void> saveUserModelToHive(UserModel userModel) async {
    final box = await Hive.openBox<UserModel>(userModelBoxName);
    await box.put('userModel', userModel);
  }

  static Future<UserModel?> getUserModelFromHive() async {
    final box = await Hive.openBox<UserModel>(userModelBoxName);
    return box.get('userModel');
  }

  static Future<void> clearHive() async {
    final box = await Hive.openBox<UserModel>(userModelBoxName);
    await box.clear();
  }
}
