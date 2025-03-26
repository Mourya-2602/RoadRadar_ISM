import 'package:mongo_dart/mongo_dart.dart';
import 'package:road_radar/backend/config/constant.dart';

class Database {
  static late Db db;
  static late DbCollection userCollection;

  static Future<void> connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    print("Connected to MongoDB successfully!");
    userCollection = db.collection(USER_COLLECTION);
  }

  static DbCollection getCollection(String name) {
    return db.collection(name);
  }
}
