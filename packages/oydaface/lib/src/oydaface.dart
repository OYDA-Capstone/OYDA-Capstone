// ignore_for_file: avoid_print

library oydaface;
import 'oydaface_condition.dart';
import 'package:postgres/postgres.dart';

/// The OYDAInterface class provides an interface for interacting with Postgresql Oydabases.
class OYDAInterface {
  /// The PostgreSQL connection object, created when the database is set
  static PostgreSQLConnection? connection;

  /// The developer key used to control developer access to different tables in the Oydabase.
  static String? devKey;

  /// Sets the connection object, allowing for interactions with the Oydabase.
  /// * [conn] specifies the PostgreSQL connection object to be set.
  static void setConnection(PostgreSQLConnection conn) {
    connection = conn;
  }

  /// Unsets the connection object, preventing further interaction with the Oydabase.
  static void unsetConnection() {
    connection = null;
  }

  /// Sets the developer key used to control developer access to different tables in the Oydabase.
  /// * [key] specifies the developer key required to access the OydaBase.
  static void setDevKey(String key) {
    devKey = key;
  }

  /// Unsets the developer key, preventing further access to the Oydabase.
  static void unsetDevKey() {
    devKey = null;
  }

  /// #### Sets up a connection to the OydaBase with the provided parameters.
  /// * [key] specifies the developer key required to access the OydaBase.
  /// * [oydabaseName] specifies the name of the database to connect to.
  /// * [host] specifies the host address of the database server.
  /// * [port] specifies the port number of the database server.
  /// * [username] specifies the username for authentication.
  /// * [password] specifies the password for authentication.
  /// * [useSSL] specifies whether to use SSL for the connection.
  /// * Throws an [Exception] if there is an issue connecting to the database.
  ///
  /// Example usage:
  /// ```dart
  /// await setOydaBase('oyda', 'localhost', 5400, 'postgres', 'okad', false);
  /// ```
  Future<void> setOydaBase(
      String? key, String oydabaseName, String host, int port, String username, String password, bool useSSL) async {
    // Check if the developer key is set
    if (key == null) {
      throw Exception('Developer Key is required to access Oydabase.');
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
      setConnection(conn);
      print('Oydabase set to "$oydabaseName"');
      setDevKey(key);
    } catch (e) {
      throw Exception('Error connecting to the oydabase: $e');
    }
  }

  /// #### Drops the set OydaBase.
  /// * Closes the connection to the database and prints a success message.
  /// * Throws an [Exception] if there is an error while dropping the database.
  Future<void> unsetOydabase() async {
    if (connection == null) {
      throw Exception('Oydabase not set. Please call setOydaBase() first.');
    }
    var oydabase = connection?.databaseName;
    await connection?.close();
    unsetConnection();
    unsetDevKey();
    print('Oydabase "$oydabase" dropped successfully');
  }

  /// #### Creates a table in a database with the given [tableName] and [columns].
  /// * [tableName] specifies the name of the table to be created.
  /// * [columns] (Map<String, String>) is a map that defines the columns of the table, where the keys represent the
  ///  column names and the values represent the column types.
  /// * Throws an [Exception] if the connection is not set.
  /// * Throws an [Exception] if there is an error creating the table.
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
    // Check if the developer key is set
    if (devKey == null) {
      throw Exception('Developer Key is required to access Oydabase.');
    }
    // Check if the connection is set
    if (connection == null) {
      throw Exception('Oydabase not set. Please call setOydaBase() first.');
    }
    // Create the table with the specified columns
    String tempName = '${tableName}_${devKey!}';
    try {
      final columnsString = columns.entries.map((entry) => '${entry.key} ${entry.value}').join(', ');
      await connection?.execute('''
        CREATE TABLE IF NOT EXISTS $tempName (
          $columnsString
        )
      ''');
      print('Table $tableName created successfully.');
    } catch (e) {
      throw Exception('Error creating table "$tableName": $e');
    }
  }

  /// #### Drops a table from the database.
  /// * [tableName] specifies the name of the table to be dropped.
  /// * If the table exists, it is dropped and a success message is printed.
  /// * Throws an [Exception] if the connection is not set.
  /// * Throws an [Exception] if there is an error dropping the table.
  ///
  /// Example usage:
  /// ```dart
  /// await dropTable('users');
  /// ```
  Future<void> dropTable(String tableName) async {
    // Check if the developer key is set
    if (devKey == null) {
      throw Exception('Developer Key is required to access Oydabase.');
    }
    // Check if the connection is set
    if (connection == null) {
      throw Exception('Oydabase not set. Please call setOydaBase() first.');
    }
    // Drop the table if it exists
    String tempName = '${tableName}_${devKey!}';
    try {
      await connection!.execute('DROP TABLE IF EXISTS $tempName');
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
  /// * [tableName] specifies the name of the table to select from.
  /// * Returns a [Future] that completes with a list of lists, where each inner list represents a row in the table.
  /// * If the table is empty or the result is null, an empty list is returned.
  /// * Throws an [Exception] if the connection is not set.
  /// * Throws an [Exception] if there is an error selecting the table.
  ///
  /// Example usage:
  /// ```dart
  /// var table = await selectTable('users');
  /// print(table);
  /// ```
  Future<List<List<dynamic>>> selectTable(String tableName) async {
    // Check if the developer key is set
    if (devKey == null) {
      throw Exception('Developer Key is required to access Oydabase.');
    }
    // Check if the connection is set
    if (connection == null) {
      throw Exception('Oydabase not set. Please call setOydaBase() first.');
    }
    String tempName = '${tableName}_${devKey!}';
    try {
      var result = await connection!.query('SELECT * FROM $tempName');
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
  /// * [tableName] specifies the name of the table to select from.
  /// * [condition] specifies the condition to be met for selecting rows. It should be a valid SQL WHERE clause.
  /// * Returns a [Future] that completes with a list of dynamic objects representing the selected rows.
  /// * If the table is empty or the result is null, an empty list is returned.
  /// * Throws an [Exception] if the connection is not set.
  /// * Throws an [Exception] if there is an error executing the select query.
  Future<List<dynamic>> selectRows(String tableName, List<Condition> condition) async {
    // Check if the developer key is set
    if (devKey == null) {
      throw Exception('Developer Key is required to access Oydabase.');
    }
    // Check if the connection is set
    if (connection == null) {
      throw Exception('Oydabase not set. Please call setOydaBase() first.');
    }
    String tempName = '${tableName}_${devKey!}';
    try {
      var conditionString = condition.map((condition) => condition.toString()).join(' AND ');
      var query = 'SELECT * FROM $tempName';
      if (conditionString.isNotEmpty) {
        print(conditionString);
        query += ' WHERE $conditionString';
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
  /// * [tableName] specifies the name of the table to select from.
  /// * [columns] is a list of column names to select.
  /// * [conditions] is a list of optional conditions to filter the selection.
  /// * Returns a [Future] that completes with a list of dynamic objects representing the selected columns.
  /// * If the selection is successful and there are matching rows, the list will contain the selected columns.
  /// * If there are no matching rows, an empty list will be returned.
  /// * Throws an [Exception] if the connection is not set.
  /// * Throws an [Exception] if an error occurs during the selection process.
  Future<List<dynamic>> selectColumns(String tableName, List<String> columns, [List<Condition>? conditions]) async {
    // Check if the developer key is set
    if (devKey == null) {
      throw Exception('Developer Key is required to access Oydabase.');
    }
    // Check if the connection is set
    if (connection == null) {
      throw Exception('Oydabase not set. Please call setOydaBase() first.');
    }
    String tempName = '${tableName}_${devKey!}';
    try {
      var conditionString = conditions?.map((condition) => condition.toString()).join(' AND ') ?? '';
      var query = 'SELECT ${columns.join(', ')} FROM $tempName';
      if (conditionString.isNotEmpty) {
        query += ' WHERE $conditionString';
      }
      var result = await connection!.query(query);
      // ignore: unrelated_type_equality_checks
      if (result != Null && result.isNotEmpty) {
        return result;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception("Error selecting columns: $e");
    }
  }
}
