import 'package:oydadb/oydadb.dart';

/// The DataManager class is responsible for managing data operations.
class DataManager {
  /// The [Utilities] instance responsible for providing helper methods for Oydabase operations.
  final Utilities utilities;

  /// The [ConnectionManager] instance responsible for managing the connection to the database.
  final ConnectionManager connectionManager;

  /// Creates an instance of the `DataManager` class with the specified `utilities` and `connectionManager`.
  DataManager(this.utilities, this.connectionManager);

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
    utilities.checkDevKey();
    utilities.checkConnection();

    // Insert a row into the specified table
    String tempName = '${tableName}_${connectionManager.devKey!}';
    try {
      final columnsString = values.entries.map((entry) => entry.key).join(', ');
      final valuesString = values.entries.map((entry) => entry.value).map((value) => "'$value'").join(', ');
      await connectionManager.connection?.execute('''
        INSERT INTO $tempName ($columnsString)
        VALUES ($valuesString)
      ''');
      print('Row inserted successfully.');
    } catch (e) {
      throw Exception('Error inserting row: $e');
    }
  }

  Future<void> updateRows() async {}

  Future<void> deleteRows() async {}

  /// Selects rows from a database table based on the provided table name and condition.
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
  /// 
  Future<List<Map<String, dynamic>>> selectRows(String tableName, List<Condition> condition) async {
    utilities.checkDevKey();
    utilities.checkConnection();

    // Select rows from the specified table based on the condition
    String tempName = '${tableName}_${connectionManager.devKey!}';
    try {
      var conditionString = condition.map((condition) => condition.toString()).join(' AND ');
      var query = 'SELECT * FROM $tempName';
      if (conditionString.isNotEmpty) {
        print(conditionString);
        query += ' WHERE $conditionString';
      }
      var result = await connectionManager.connection!.query(query);
      // ignore: unrelated_type_equality_checks
      if (result != Null && result.isNotEmpty) {
        List<Map<String, dynamic>> table = [];
        for (var row in result) {
          Map<String, dynamic> rowMap = {};
          for (int i = 0; i < result.columnDescriptions.length; i++) {
            rowMap[result.columnDescriptions[i].columnName] = row[i];
          }
          table.add(rowMap);
        }
        return table;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception("Error selecting rows: $e");
    }
  }

  /// Selects specific columns from a table in the database.
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
    utilities.checkDevKey();
    utilities.checkConnection();

    // Select specific columns from the specified table
    String tempName = '${tableName}_${connectionManager.devKey!}';
    try {
      var conditionString = conditions?.map((condition) => condition.toString()).join(' AND ') ?? '';
      var query = 'SELECT ${columns.join(', ')} FROM $tempName';
      if (conditionString.isNotEmpty) {
        query += ' WHERE $conditionString';
      }
      var result = await connectionManager.connection!.query(query);
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
