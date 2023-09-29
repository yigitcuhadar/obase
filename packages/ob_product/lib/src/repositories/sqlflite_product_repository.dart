import 'dart:async';
import 'dart:io';

import 'package:ob_product/ob_product.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SqlfliteProductRepository extends ProductRepository {
  Database? _db;

  static const String _productsTableId = 'products';
  static const String _barcodesTableId = 'barcodes';

  Future<Database> get db async {
    if (_db == null) {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = '${documentsDirectory.path}/ObaseDB.db';
      _db = await openDatabase(
        path,
        version: 2,
        onCreate: _onCreate,
        onConfigure: _onConfigure,
      );
    }
    return _db!;
  }

  void _onCreate(Database database, int version) async {
    await database.transaction((txn) async {
      await txn.execute("CREATE TABLE $_productsTableId ("
          "id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
          "name TEXT NOT NULL,"
          "description TEXT NOT NULL,"
          "photoUrl TEXT NOT NULL,"
          "stockQuantity INTEGER NOT NULL"
          ")");
      await txn.execute("CREATE TABLE $_barcodesTableId ("
          "id INTEGER NOT NULL PRIMARY KEY,"
          "productId INTEGER NOT NULL,"
          "FOREIGN KEY(productId) REFERENCES products(id) ON DELETE CASCADE "
          "UNIQUE (id, productId)"
          ")");
    });
  }

  void _onConfigure(Database database) async {
    await database.execute('PRAGMA foreign_keys = ON');
  }

  @override
  Future<List<Product>> getAll() async {
    final Database database = await db;
    final List<Product> products = (await database.rawQuery(
            "SELECT p.id AS id, p.name AS name, p.description AS description, p.photoUrl AS photoUrl, GROUP_CONCAT(CAST(b.id AS TEXT),'/') AS barcodes , p.stockQuantity as stockQuantity "
            "FROM $_productsTableId p "
            "LEFT JOIN $_barcodesTableId b ON p.id == b.productId "
            "GROUP BY p.id"))
        .map(
          (e) => Product.fromJson(e),
        )
        .toList();
    return products;
  }

  @override
  Future<Product?> getProduct(int id) async {
    final Database database = await db;
    List<Map<String, dynamic>> result = await database.query(
      _productsTableId,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return Product.fromJson(result[0]);
    } else {
      return null;
    }
  }

  @override
  Future<int> addProduct(Product product) async {
    final Database database = await db;
    int id = await database.insert(
      _productsTableId,
      ProductEntity.fromProduct(product).toJson()..remove('id'),
    );
    return id;
  }

  @override
  Future<void> deleteProduct(int id) async {
    final Database database = await db;
    await database.delete(
      _productsTableId,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> updateProduct(Product product) async {
    final Database database = await db;
    await database.update(
      _productsTableId,
      ProductEntity.fromProduct(product).toJson(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  @override
  Future<void> updateAllProducts(List<Product> products) async {
    final Database database = await db;
    await database.transaction((txn) async {
      for (Product product in products) {
        await txn.update(
          _productsTableId,
          ProductEntity.fromProduct(product).toJson(),
          where: 'id = ?',
          whereArgs: [product.id],
        );
      }
    });
  }

  @override
  Future<Barcode?> getBarcode(int id) async {
    final Database database = await db;
    List<Map<String, dynamic>> result = await database.query(
      _barcodesTableId,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return Barcode.fromJson(result[0]);
    } else {
      return null;
    }
  }

  @override
  Future<void> addBarcode(int id, int productId) async {
    final Database database = await db;
    await database.insert(
      _barcodesTableId,
      BarcodeEntity(id, productId).toJson(),
    );
  }

  @override
  Future<void> deleteBarcode(int id) async {
    final Database database = await db;
    await database.delete(
      _barcodesTableId,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
