import 'package:oydadb/oydadb.dart';

/// The `TableManager` class provides methods for creating, dropping, and selecting tables in a database.
class TableManager {
  /// The [ConnectionManager] instance responsible for managing the connection to the database.
  final ConnectionManager connectionManager;

  /// The [Utilities] instance responsible for providing helper methods for Oydabase operations.
  final Utilities utilities;

  /// Creates an instance of the `TableManager` class with the specified `connectionManager` and `utilities`.
  TableManager(this.connectionManager, this.utilities);

  /// Creates a table in a database with the given [tableName] and [columns].
  /// - [tableName] specifies the name of the table to be created.
  /// - [columns] (Map<String, String>) is a map that defines the columns of the table, where the keys represent the
  ///  column names and the values represent the column types.
  ///
  /// If the table already exists, a warning message is printed.
  /// 
  /// Throws an [Exception] if the connection is not set or if there is an error creating the table.
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
    utilities.checkDevKey();
    utilities.checkConnection();

    // Create the table with the specified columns
    String tempName = '${tableName}_${connectionManager.devKey!}';
    try {
      final columnsString = columns.entries.map((entry) => '${entry.key} ${entry.value}').join(', ');
      await connectionManager.connection?.execute('''
        CREATE TABLE IF NOT EXISTS $tempName (
          $columnsString
        )
      ''');
      if (await tableExists(tempName)) {
        print('Warning: Table "$tableName" already exists.');
      } else {
        print('Table "$tableName" created successfully.');
      }
    } catch (e) {
      throw Exception('Error creating table "$tableName": $e');
    }
  }

  /// Checks if a table exists in the database.
  /// - [tableName] specifies the name of the table to check for existence.
  ///
  /// Returns a [Future] that completes with a boolean value indicating whether the table exists.
  Future<bool> tableExists(String tableName) async {
    try {
      var result = await connectionManager.connection?.query('SELECT 1 FROM $tableName LIMIT 1');
      return result != null && result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Drops a table from the database.
  /// - [tableName] specifies the name of the table to be dropped.
  /// - If the table exists, it is dropped and a success message is printed.
  ///
  /// Throws an [Exception] if the connection is not set or if there is an error dropping the table.
  ///
  /// Example usage:
  /// ```dart
  /// await dropTable('users');
  /// ```
  Future<void> dropTable(String tableName) async {
    utilities.checkDevKey();
    utilities.checkConnection();

    // Drop the table if it exists
    String tempName = '${tableName}_${connectionManager.devKey!}';
    try {
      await connectionManager.connection!.execute('DROP TABLE IF EXISTS $tempName');
      print('Table "$tableName" dropped successfully.');
    } catch (e) {
      throw Exception('Error dropping table "$tableName": $e');
    }
  }

  /// Retrieves all rows from the specified table in the database.
  /// - [tableName] specifies the name of the table to select from.
  ///
  /// Returns a [Future] that completes with a list of lists, where each inner list represents a row in the table.
  /// If the table is empty or the result is null, an empty list is returned.
  /// 
  /// Throws an [Exception] if the connection is not set or if there is an error selecting the table.
  ///
  /// Example usage:
  /// ```dart
  /// var table = await selectTable('users');
  /// print(table);
  /// ```
  Future<List<List<dynamic>>> selectTable(String tableName) async {
    utilities.checkDevKey();
    utilities.checkConnection();

    // Select all rows from the specified table
    String tempName = '${tableName}_${connectionManager.devKey!}';
    try {
      var result = await connectionManager.connection!.query('SELECT * FROM $tempName');
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
}
