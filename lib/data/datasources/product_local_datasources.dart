import 'package:fic11_starter_pos/data/model/response/product_response_model.dart';
import 'package:fic11_starter_pos/presentation/home/models/order_item.dart';
import 'package:fic11_starter_pos/presentation/order/models/order_model.dart';
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
        image TEXT,
        is_best_seller INTEGER,
        is_sync INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nominal INTEGER,
        payment_method TEXT,
        total_item INTEGER,
        id_kasir INTEGER,
        nama_kasir TEXT,
        is_sync INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE orders_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_order INTEGER,
        id_product INTEGER,
        quantity INTEGER,
        price INTEGER
      )
    ''');
  }

  //save order
  Future<int> saveOrder(OrderModel order) async {
    final db = await instance.database;
    int id = await db.insert('orders', order.toMapForLocal());
    for (var orderItem in order.orders) {
      await db.insert('orders_items', orderItem.toMapForLocal(id));
    }
    return id;
  }

  //get order by isSync = 0
  Future<List<OrderModel>> getOrdersByIsSync() async {
    final db = await instance.database;
    final result = await db.query('orders', where: 'is_sync = 0');
    return result.map((e) => OrderModel.fromLocalMap(e)).toList();
  }

  //get order item By id order
  Future<List<OrderItem>> getOrderItemByOrderId(int idOrder) async {
    final db = await instance.database;
    final result = await db.query('orders_items', where: 'id_order = $idOrder');
    return result.map((e) => OrderItem.fromMap(e)).toList();
  }

  //update isSync
  Future<int> updateIsSyncOrderById(int id) async {
    final db = await instance.database;
    return await db.update('orders', {'is_sync': 1}, where: 'id = $id');
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

  //insert product
  Future<Product> insertProduct(Product product) async {
    final db = await instance.database;
    int id = await db.insert(tableProducts, product.toMap());
    return product.copyWith(id: id);
  }

  Future<List<Product>> getAllProducts() async {
    final db = await instance.database;
    final result = await db.query(tableProducts);

    return result.map((e) => Product.fromMap(e)).toList();
  }
}
