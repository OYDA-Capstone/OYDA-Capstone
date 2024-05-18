import 'package:oydadb/oydadb.dart';

/// This class provides the public interface for interacting with an Oydabase.
class OYDAInterface {
  /// The singleton instance of the `OYDAInterface` class.
  static final OYDAInterface _instance = OYDAInterface._internal();

  /// The factory constructor for the `OYDAInterface` class.
  factory OYDAInterface() {
    return _instance;
  }

  /// Creates an instance of the `OYDAInterface` class with the necessary default instances for Oydabase operations.
  OYDAInterface._internal()
      : connectionManager = ConnectionManager(),
        utilities = Utilities(ConnectionManager()),
        dataManager = DataManager(Utilities(ConnectionManager()), ConnectionManager()),
        tableManager = TableManager(ConnectionManager(), Utilities(ConnectionManager()));

  /// The [ConnectionManager] instance responsible for managing the connection to the database.
  final ConnectionManager connectionManager;

  /// The [Utilities] instance responsible for providing helper methods for Oydabase operations.
  final Utilities utilities;

  /// The [DataManager] instance responsible for managing data operations.
  final DataManager dataManager;

  /// The [TableManager] instance responsible for managing table operations.
  final TableManager tableManager;

  /// Sets the Oydabase connection with the specified parameters.
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
    await connectionManager.setOydaBase(key, oydabaseName, host, port, username, password, useSSL);
  }

  /// Unsets the Oydabase connection.
  ///
  /// Closes the connection to the database and prints a success message.
  /// 
  /// Throws an [Exception] if there is an error while dropping the database.
  Future<void> unsetOydabase() async {
    await connectionManager.unsetOydabase();
  }

  /// Creates a table in the oydabase with the given [tableName] and [columns].
  /// 
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
    await tableManager.createTable(tableName, columns);
  }

  /// Drops a table from the oydabase with the given [tableName].
  /// 
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
    await tableManager.dropTable(tableName);
  }

  /// Checks if a table with the given [tableName] exists in the oydabase.
  /// 
  /// - [tableName] specifies the name of the table to check for existence.
  ///
  /// Returns a [Future] that completes with a boolean value indicating whether the table exists.
  Future<bool> tableExists(String tableName) async {
    return await tableManager.tableExists(tableName);
  }

  /// Selects table with the given [tableName] from the oydabase.
  /// 
  /// - [tableName] specifies the name of the table to select from.
  ///
  /// Returns a [Future] that completes with a list of dictionaries, where each dictionary represents a row in the table.
  /// If the table is empty or the result is null, an empty list is returned.
  ///
  /// Throws an [Exception] if the connection is not set or if there is an error selecting the table.
  ///
  /// Example usage:
  /// ```dart
  /// var table = await selectTable('users');
  /// print(table);
  /// ```
  Future<List<Map<String, dynamic>>> selectTable(String tableName) async {
    return await tableManager.selectTable(tableName);
  }

  /// Inserts rows into a table with the given [tableName] in the oydabase.
  /// 
  /// - [tableName] specifies the name of the table to select from.
  /// - [values] specifies the values to be inserted into the table. It should be a map where the keys represent the column names.
  ///
  /// Throws an [Exception] if the connection is not set or if there is an error executing the select query.
  ///
  /// Example usage:
  /// ```dart
  /// const tableName = 'test_table';
  /// final columns = {
  ///      'id': 'SERIAL PRIMARY KEY',
  ///     'name': 'VARCHAR(255)',
  ///    'age': 'INTEGER',
  /// };
  /// await oydaInterface.createTable(tableName, columns);
  /// await oydaInterface.insertRows('test_table', {'name': 'Oheneba', 'age': '18'});
  /// ```
  Future<void> insertRows(String tableName, Map<String, String> values) async {
    await dataManager.insertRows(tableName, values);
  }

  /// Updates rows in a table in the oydabase.
  Future<void> updateRow() async {
    await dataManager.updateRows();
  }

  /// Deletes rows from a table in the oydabase.
  Future<void> deleteRow() async {
    await dataManager.deleteRows();
  }

  /// Selects rows that satisfy the given [conditions] from a table with the given [tableName] in the oydabase.
  ///
  /// - [tableName] specifies the name of the table to select from.
  /// - [condition] specifies the condition to be met for selecting rows. It should be a valid SQL WHERE clause.
  ///
  /// Returns a [Future] that completes with a list of dictionaries representing the selected rows.
  /// If the table is empty or the result is null, an empty list is returned.
  ///
  /// Throws an [Exception] if the connection is not set or if there is an error executing the select query.
  /// 
  /// Example usage:
  /// ```dart
  /// var rows = await oydaInterface.selectRows('test_table', [Condition('name', '=', 'Oheneba')]);
  /// print(rows);
  /// ```
  Future<List<Map<String, dynamic>>> selectRows(String tableName, List<Condition> condition) async {
    return await dataManager.selectRows(tableName, condition);
  }

  /// Selects columns that satisfy the given [conditions] from a table with the given [tableName] in the oydabase.
  ///
  /// - [tableName] specifies the name of the table to select from.
  /// - [columns] is a list of column names to select.
  /// - [conditions] is a list of optional conditions to filter the selection.
  ///
  /// Returns a [Future] that completes with a list of dynamic objects representing the selected columns.
  ///
  /// If the selection is successful and there are matching rows, the list will contain the selected columns.
  /// If there are no matching rows, an empty list will be returned.
  ///
  /// Throws an [Exception] if the connection is not set or if an error occurs during the selection process.
  /// 
  /// Example usage:
  /// ```dart
  /// var columns1 = await oydaInterface.selectColumns('test_table', ['name', 'age']);
  /// print(columns1);
  /// ```
  Future<List<dynamic>> selectColumns(String tableName, List<String> columns, [List<Condition>? conditions]) async {
    return await dataManager.selectColumns(tableName, columns, conditions);
  }
}
