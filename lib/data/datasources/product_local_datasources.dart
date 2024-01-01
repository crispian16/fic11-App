import 'package:fic11_starter_pos/data/model/response/product_response_model.dart';
import 'package:sqflite/sqflite.dart';

class ProductLocalDatasources {
  ProductLocalDatasources._init();

  static final ProductLocalDatasources instance =
      ProductLocalDatasources._init();

  final String tableProducts = 'products';

  static Database? _database;

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + filePath;

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableProducts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        price INTEGER,
        stock INTEGER,
        category TEXT,
        image TEXT
      )
    ''');
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('pos1.db');
    return _database!;
  }

  Future<void> removeAllProducts() async {
    final db = await instance.database;
    await db.delete(tableProducts);
  }

  Future<void> insertAllProduct(List<Product> products) async {
    final db = await instance.database;
    for (var product in products) {
      await db.insert(tableProducts, product.toMap());
    }
  }

  Future<List<Product>> getAllProducts() async {
    final db = await instance.database;
    final result = await db.query(tableProducts);

    return result.map((e) => Product.fromMap(e)).toList();
  }
}
