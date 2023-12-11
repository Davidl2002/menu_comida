// database_helper.dart
// ignore_for_file: avoid_print, use_rethrow_when_possible

// database_helper.dart
import 'package:postgres/postgres.dart';

class DatabaseHelper {
  static Future<PostgreSQLConnection> openConnection() async {
    final connection = PostgreSQLConnection(
      "roundhouse.proxy.rlwy.net",
      49265,
      "railway",
      username: "postgres",
      password: "CGbDFF*ABcg14D632A2c666cdBBB25*e",
      useSSL: true,
    );

    try {
      await connection.open();
      print("Conectado a la base");
      return connection;
    } catch (e) {
      print("Error opening connection: $e");
      throw e;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchCategories(
      PostgreSQLConnection connection) async {
    try {
      final results = await connection.query('SELECT * FROM CATEGORIAS');
      return results.map((result) => result.toColumnMap()).toList();
    } catch (e) {
      print("Error fetching categories: $e");
      throw e;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchProducts(
      PostgreSQLConnection connection, String categoryId) async {
    try {
      final results = await connection.query(
        'SELECT * FROM PRODUCTOS WHERE ID_CAT_PER = @categoryId',
        substitutionValues: {'categoryId': categoryId},
      );
      return results.map((result) => result.toColumnMap()).toList();
    } catch (e) {
      print("Error fetching products: $e");
      throw e;
    }
  }
}
