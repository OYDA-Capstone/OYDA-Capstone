import 'package:postgres/postgres.dart';

/// The ConnectionManager class is responsible for managing the connection to the OydaBase.
class ConnectionManager {
  /// The singleton instance of the ConnectionManager class.
  static ConnectionManager? _instance;

  /// The factory constructor for the ConnectionManager class.
  factory ConnectionManager() {
    if (_instance == null) {
      _instance ??= ConnectionManager._internal();
    }
    return _instance!;
  }

  /// The internal constructor for the ConnectionManager class.
  ConnectionManager._internal();

  /// The PostgreSQL connection object, created when the database is set
  PostgreSQLConnection? connection;

  /// The developer key required to access the OydaBase
  String? devKey;

  /// Sets the connection to the OydaBase.
  ///
  /// - [conn] specifies the PostgreSQL connection object to be set.
  void setConnection(PostgreSQLConnection conn) {
    connection = conn;
  }

  /// Unsets the connection by setting it to null.
  void unsetConnection() {
    connection = null;
  }

  /// Sets the developer key for the OydaBase.
  ///
  /// - [key] specifies the developer key required to access the OydaBase.
  void setDevKey(String key) {
    devKey = key;
  }

  /// Unsets the developer key for the OydaBase.
  void unsetDevKey() {
    devKey = null;
  }

  /// Sets up a connection to the OydaBase with the provided parameters.
  ///
  /// - [key] specifies the developer key required to access the OydaBase.
  /// - [oydabaseName] specifies the name of the database to connect to.
  /// - [host] specifies the host address of the database server.
  /// - [port] specifies the port number of the database server.
  /// - [username] specifies the username for authentication.
  /// - [password] specifies the password for authentication.
  /// - [useSSL] specifies whether to use SSL for the connection.
  ///
  /// Throws an [Exception] if there is an issue connecting to the database.
  ///
  /// Example usage:
  /// ```dart
  /// await setOydaBase('77775432', 'oydadb', 'oydaserver.postgres.database.azure.com', 5432, 'admin', 'admin123', true);
  /// ```
  Future<void> setOydaBase(
      String? key, String oydabaseName, String host, int port, String username, String password, bool useSSL) async {
    // Check if the developer key is set
    if (key == null) {
      throw Exception('Developer Key is required to set Oydabase.');
    }
    // Check if the connection is already set
    if (connection != null) {
      if (connection!.databaseName == oydabaseName) {
        print('Oydabase already set to "$oydabaseName"');
        return;
      } else {
        unsetOydabase();
        unsetDevKey();
      }
    }
    // Create a new connection to the database
    var conn = PostgreSQLConnection(host, port, oydabaseName, username: username, password: password, useSSL: useSSL);
    try {
      await conn.open();
      print('Oydabase set to "$oydabaseName"');
      setConnection(conn);
      setDevKey(key);
    } catch (e) {
      throw Exception('Error connecting to the oydabase: $e');
    }
  }

  /// Drops the set OydaBase.
  ///
  /// Closes the connection to the database and prints a success message.
  /// 
  /// Throws an [Exception] if there is an error while dropping the database.
  Future<void> unsetOydabase() async {
    var oydabase = connection?.databaseName;
    await connection?.close();
    unsetConnection();
    unsetDevKey();
    print('Oydabase "$oydabase" dropped successfully');
  }
}
