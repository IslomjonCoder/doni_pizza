import 'package:uuid/uuid.dart';

class UidGenerator {
  static const Uuid _uid = Uuid();

  static String generateUID() => _uid.v4();
}
