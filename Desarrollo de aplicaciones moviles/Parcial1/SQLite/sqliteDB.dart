import 'package:parcial/models/products.dart';
import 'package:parcial/exports.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteDB {
  static Future<Database> _openDB() async {
    return openDatabase(join(await getDatabasesPath(), 'Products.db'),
        onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE products (id TEXT PRIMARY KEY, name TEXT, description TEXT, photo TEXT, price REAL)",
      );
    }, version: 1);
  }

  static Future<void> saveFavorites(List<Product> products) async {
    final db = await _openDB();

    final batch = db.batch();

    for (final product in products) {
      batch.insert(
        'products',
        product.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit();
  }

  static Future<bool> existsFavorite(String id) async {
    Database database = await _openDB();

    final result = await database.query('products',
        where: "id = ?", whereArgs: [id], limit: 1);

    return result.isNotEmpty;
  }

  static Future<void> insert(Product product) async {
    Database database = await _openDB();

    database.insert('products', product.toJson());
  }

  static Future<void> delete(String id) async {
    Database database = await _openDB();

    database.delete('products', where: "id = ?", whereArgs: [id]);
  }

  static Future<List<Product>> getFavorites() async {
    Database database = await _openDB();
    String idUser = SharedService.prefs.getString('id') ?? 'default';
    if (idUser == 'default') {
      return [];
    }
    final List<Map<String, dynamic>> products =
        await database.query('products');

    return List.generate(
        products.length,
        (index) => Product(
            id: products[index]['id'],
            name: products[index]['name'],
            description: products[index]['description'],
            photo: products[index]['photo'],
            price: products[index]['price']));
  }

  static Future<List<String>> getFavoritesListIds() async {
    Database database = await _openDB();
    String idUser = SharedService.prefs.getString('id') ?? 'default';
    if (idUser == 'default') {
      return [];
    }
    final List<Map<String, dynamic>> products =
        await database.query('products');

    return List.generate(
      products.length,
      (index) => products[index]['id'],
    );
  }

  static Future<void> deleteFavorites() async {
    Database database = await _openDB();
    await database.execute("DELETE FROM products");
  }
}
