// ignore_for_file: avoid_print

library oydadb;

import 'package:postgres/postgres.dart';

class OYDAInterface {
  /// #### The PostgreSQL connection object, created when the database is set
  PostgreSQLConnection? connection;

  /// #### Sets up a connection to the OydaBase with the provided parameters.
  ///
  /// * [oydabaseName] specifies the name of the database to connect to.
  /// * [host] specifies the host address of the database server.
  /// * [port] specifies the port number of the database server.
  /// * [username] specifies the username for authentication.
  /// * [password] specifies the password for authentication.
  /// * [useSSL] specifies whether to use SSL for the connection.
  /// * Throws an error if there is an issue connecting to the database.
  ///
  /// Example usage:
  /// ```dart
  /// await setOydaBase('oyda', 'localhost', 5400, 'postgres', 'okad', false);
  /// ```
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
      throw Exception('Error connecting to the oydabase: $e');
    }
  }

  /// #### Drops the set OydaBase.
  ///
  /// * Closes the connection to the database and prints a success message.
  /// * Throws an exception if there is an error while dropping the database.
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
  /// * Throws an exception if there is an error creating the table.
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
      throw Exception('Error creating table "$tableName": $e');
    }
  }

  /// #### Drops a table from the database.
  ///
  /// * [tableName] specifies the name of the table to be dropped.
  /// * If the [connection] is not set, an exception is thrown.
  /// * If the table exists, it is dropped and a success message is printed.
  /// * Throws an exception if there is an error dropping the table.
  ///
  /// Example usage:
  /// ```dart
  /// await dropTable('users');
  /// ```
  Future<void> dropTable(String tableName) async {
    if (connection == null) {
      throw Exception('Oydabase not set. Please call setOydaBase() first.');
    }
    try {
      await connection!.execute('DROP TABLE IF EXISTS $tableName');
      print('Table $tableName dropped successfully.');
    } catch (e) {
      throw Exception('Error dropping table "$tableName": $e');
    }
  }

  Future<void> insertRow() async {}

  Future<void> updateRow() async {}

  Future<void> selectRow() async {}

  Future<void> deleteRow() async {}

  /// #### Retrieves all rows from the specified table in the database.
  ///
  /// * [tableName] specifies the name of the table to select from.
  /// * Returns a [Future] that completes with a list of lists, where each inner list represents a row in the table.
  /// * If the table is empty or the result is null, an empty list is returned.
  /// * Throws an exception if there is an error selecting the table.
  /// 
  /// Example usage:
  /// ```dart
  /// var table = await selectTable('users');
  /// print(table);
  /// ```
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
      throw Exception('Error selecting table: $e');
    }
  }

  /// #### Selects rows from a database table based on the provided table name and condition.
  ///
  /// * [tableName] specifies the name of the table to select from.
  /// * [condition] specifies the condition to be met for selecting rows. It should be a valid SQL WHERE clause.  
  /// * Returns a [Future] that completes with a list of dynamic objects representing the selected rows.
  /// * If the table is empty or the result is null, an empty list is returned.
  /// * Throws an exception if there is an error executing the select query.
  Future<List<dynamic>> selectRows(String tableName, String condition) async {
    if (connection == null) {
      throw Exception('Oydabase not set. Please call setOydaBase() first.');
    }
    try {
      var query = 'SELECT * FROM $tableName';
      if (condition.isNotEmpty) {
        query += ' WHERE $condition';
      }
      var result = await connection!.query(query);
      // ignore: unrelated_type_equality_checks
      if (result != Null && result.isNotEmpty) {
        return result;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception("Error selecting rows: $e");
    }
  }

  /// #### Selects specific columns from a table in the database.
  ///
  /// * [tableName] specifies the name of the table to select from.
  /// * [columns] is a list of column names to select.
  /// * [condition] is an optional condition to filter the selection.
  /// * Returns a [Future] that completes with a list of dynamic objects representing the selected columns.
  /// * If the selection is successful and there are matching rows, the list will contain the selected columns.
  /// * If there are no matching rows, an empty list will be returned.
  /// * Throws an [Exception] if an error occurs during the selection process.
  Future<List<dynamic>> selectColumns(String tableName, List<String> columns, [String condition = '']) async {
    if (connection == null) {
      throw Exception('Oydabase not set. Please call setOydaBase() first.');
    }
    try {
      var query = 'SELECT ${columns.join(', ')} FROM $tableName';
      if (condition.isNotEmpty) {
        query += ' WHERE $condition';
      }
      var result = await connection!.query(query);
      // ignore: unrelated_type_equality_checks
      if (result != Null && result.isNotEmpty) {
        return result;
      }else{
        return [];
      }
    } catch (e) {
      throw Exception("Error selecting columns: $e");
    }
  }
}
