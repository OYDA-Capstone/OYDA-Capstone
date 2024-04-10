// ignore_for_file: avoid_print

library oydadb;

import 'package:postgres/postgres.dart';

class OYDAInterface {
  /// The PostgreSQL connection object, created when the database is set
  PostgreSQLConnection? connection;

  /// ### Sets up a connection to the OydaBase with the provided parameters.
  ///
  /// * [oydabaseName] specifies the name of the database to connect to.
  /// * [host] specifies the host address of the database server.
  /// * [port] specifies the port number of the database server.
  /// * [username] specifies the username for authentication.
  /// * [password] specifies the password for authentication.
  /// * [useSSL] specifies whether to use SSL for the connection.
  ///
  /// Throws an error if there is an issue connecting to the database.
  Future<void> setOydaBase(
      String oydabaseName, String host, int port, String username, String password, bool useSSL) async {
    var conn = PostgreSQLConnection(host, port, oydabaseName, username: username, password: password, useSSL: useSSL);
    try {
      await conn.open();
      print('Oydabase set to $oydabaseName');
      connection = conn;
    } catch (e) {
      print('Error connecting to the oydabase: $e');
    }
  }

  /// ### Creates a table in a database with the given [tableName] and [columns].
  ///
  /// * [tableName] specifies the name of the table to be created.
  /// * [columns] (Map<String, String>) is a map that defines the columns of the table, where the keys represent the
  ///  column names and the values represent the column types.
  ///
  /// Example usage:
  /// ```dart
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
    try {
      // await connection?.open();
      final columnsString = columns.entries.map((entry) => '${entry.key} ${entry.value}').join(', ');
      await connection?.execute('''
        CREATE TABLE IF NOT EXISTS $tableName (
          $columnsString
        )
      ''');
      print('Table $tableName created successfully.');
    } catch (e) {
      print('Error creating table $tableName: $e');
    }
  }
}
