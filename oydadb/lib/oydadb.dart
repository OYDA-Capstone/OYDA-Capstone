// ignore_for_file: avoid_print

library oydadb;

import 'package:postgres/postgres.dart';

class OYDAInterface {
  /// The PostgreSQL connection object, created when the database is set
  PostgreSQLConnection? connection;

  /// #### Sets up a connection to the OydaBase with the provided parameters.
  ///
  /// * [oydabaseName] specifies the name of the database to connect to.
  /// * [host] specifies the host address of the database server.
  /// * [port] specifies the port number of the database server.
  /// * [username] specifies the username for authentication.
  /// * [password] specifies the password for authentication.
  /// * [useSSL] specifies whether to use SSL for the connection.
  ///
  /// Example usage:
  /// ```dart
  /// await setOydaBase('oyda', 'localhost', 5400, 'postgres', 'okad', false);
  /// ```
  ///
  /// Throws an error if there is an issue connecting to the database.
  Future<void> setOydaBase(
      String oydabaseName, String host, int port, String username, String password, bool useSSL) async {
    if (connection != null) {
      if (connection!.databaseName == oydabaseName) {
        print('Oydabase already set to "$oydabaseName"');
        return;
      } else {
        unsetOydabase();
      }
    }
    var conn = PostgreSQLConnection(host, port, oydabaseName, username: username, password: password, useSSL: useSSL);
    try {
      await conn.open();
      print('Oydabase set to "$oydabaseName"');
      connection = conn;
    } catch (e) {
      print('Error connecting to the oydabase: $e');
    }
  }

  /// #### Drops the set OydaBase.
  ///
  /// Closes the connection to the database and prints a success message.
  ///
  /// Throws an exception if there is an error while dropping the database.
  Future<void> unsetOydabase() async {
    var oydabase = connection?.databaseName;
    await connection?.close();
    print('Oydabase "$oydabase" dropped successfully');
  }

  /// #### Creates a table in a database with the given [tableName] and [columns].
  ///
  /// * [tableName] specifies the name of the table to be created.
  /// * [columns] (Map<String, String>) is a map that defines the columns of the table, where the keys represent the
  ///  column names and the values represent the column types.
  ///
  /// Example usage:
  /// ```dart
  /// const tableName = 'users';
  /// final columns = {
  ///   'id': 'SERIAL PRIMARY KEY',
  ///   'name': 'VARCHAR(255)',
  ///   'age': 'INT',
  /// };
  /// await createTable('users', columns);
  /// ```
  ///
  /// Throws an exception if there is an error creating the table.
  Future<void> createTable(String tableName, Map<String, String> columns) async {
    if (connection == null) {
      throw Exception('Oydabase not set. Please call setOydaBase() first.');
    }
    try {
      final columnsString = columns.entries.map((entry) => '${entry.key} ${entry.value}').join(', ');
      await connection?.execute('''
        CREATE TABLE IF NOT EXISTS $tableName (
          $columnsString
        )
      ''');
      print('Table $tableName created successfully.');
    } catch (e) {
      print('Error creating table "$tableName": $e');
    }
  }

  /// #### Retrieves all rows from the specified table in the database.
  ///
  /// * The [tableName] parameter specifies the name of the table to select from.
  /// * Returns a [Future] that completes with a list of lists, where each inner list represents a row in the table.
  /// * If the table is empty or the result is null, an empty list is returned.
  /// * Throws an [Exception] if the [connection] is null. Call [setOydaBase()] before calling this method.
  ///
  /// Example usage:
  /// ```dart
  /// var table = await selectTable('users');
  /// print(table);
  /// ```
  ///
  /// Throws an exception if there is an error selecting the table.
  Future<List<List<dynamic>>> selectTable(String tableName) async {
    if (connection == null) {
      throw Exception('Oydabase not set. Please call setOydaBase() first.');
    }
    try {
      var result = await connection!.query('SELECT * FROM $tableName');
      // ignore: unrelated_type_equality_checks
      if (result != Null && result.isNotEmpty) {
        return result;
      } else {
        return [];
      }
    } catch (e) {
      print('Error selecting table: $e');
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  Future<List<dynamic>> selectFromTable() async {
    return [];
  }

  /// #### Drops a table from the database.
  ///
  /// * The [tableName] parameter specifies the name of the table to be dropped.
  /// * If the [connection] is not set, an exception is thrown.
  /// * If the table exists, it is dropped and a success message is printed.
  /// * If an error occurs while dropping the table, an error message is printed.
  /// 
  /// Example usage:
  /// ```dart
  /// await dropTable('users');
  /// ```
  /// 
  /// Throws an exception if there is an error dropping the table.
  Future<void> dropTable(String tableName) async {
    if (connection == null) {
      throw Exception('Oydabase not set. Please call setOydaBase() first.');
    }
    try {
      await connection!.execute('DROP TABLE IF EXISTS $tableName');
      print('Table $tableName dropped successfully.');
    } catch (e) {
      print('Error dropping table "$tableName": $e');
    }
  }

  Future<void> insertRow() async {}

  Future<void> updateRow() async {}

  Future<void> deleteRow() async {}

  Future<void> selectRow() async {}

  Future<void> selectAllRows() async {}
}
