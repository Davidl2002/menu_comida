import 'package:postgres/postgres.dart';

class DbConnection {
  static late PostgreSQLConnection _connection;

  static Future<PostgreSQLConnection> openConnection() async {
    _connection = PostgreSQLConnection(
      'localhost',
      5432,
      'nombre_de_tu_base_de_datos',
      username: 'tu_nombre_de_usuario',
      password: 'tu_contraseña',
    );

    await _connection.open();

    return _connection;
  }

  static Future<void> closeConnection() async {
    // ignore: unnecessary_null_comparison
    if (_connection != null && !_connection.isClosed) {
      await _connection.close();
    }
  }
}
