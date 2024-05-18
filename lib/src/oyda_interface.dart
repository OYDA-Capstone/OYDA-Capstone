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
  Future<void> setOydaBase(
      String? key, String oydabaseName, String host, int port, String username, String password, bool useSSL) async {
    await connectionManager.setOydaBase(key, oydabaseName, host, port, username, password, useSSL);
  }

  /// Unsets the Oydabase connection.
  Future<void> unsetOydabase() async {
    await connectionManager.unsetOydabase();
  }

  /// Creates a table in the oydabase with the given [tableName] and [columns].
  Future<void> createTable(String tableName, Map<String, String> columns) async {
    await tableManager.createTable(tableName, columns);
  }

  /// Drops a table from the oydabase with the given [tableName].
  Future<void> dropTable(String tableName) async {
    await tableManager.dropTable(tableName);
  }

  /// Checks if a table with the given [tableName] exists in the oydabase.
  Future<bool> tableExists(String tableName) async {
    return await tableManager.tableExists(tableName);
  }

  /// Selects table with the given [tableName] from the oydabase.
  Future<List<List<dynamic>>> selectTable(String tableName) async {
    return await tableManager.selectTable(tableName);
  }

  /// Inserts rows into a table with the given [tableName] in the oydabase.
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
  Future<List<dynamic>> selectRows(String tableName, List<Condition> condition) async {
    return await dataManager.selectRows(tableName, condition);
  }

  /// Selects columns that satisfy the given [conditions] from a table with the given [tableName] in the oydabase.
  Future<List<dynamic>> selectColumns(String tableName, List<String> columns, [List<Condition>? conditions]) async {
    return await dataManager.selectColumns(tableName, columns, conditions);
  }
}
