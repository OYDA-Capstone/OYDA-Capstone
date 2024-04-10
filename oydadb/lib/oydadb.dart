library oydadb;

import 'package:postgres/postgres.dart';

class OYDAInterface {
  //TODO: Create an instance variable that stores the name of the database that has been set by the setDB function to be used in other functions.
  //Replace the hard-coded 'oyda' with the instance variable

  /// The function `createTable` creates a table in a PostgreSQL database with the specified table name
  /// and columns.
  ///
  /// Args:
  ///   tableName (String): The `tableName` parameter is a String that represents the name of the table
  /// you want to create in the database.
  ///   columns (Map<String, String>): The `columns` parameter in the `createTable` function is a map
  /// where the keys represent the column names and the values represent the data types of those
  /// columns.
  Future<void> createTable(
      String tableName, Map<String, String> columns) async {
    final conn = PostgreSQLConnection('localhost', 5433, 'oyda',
        username: 'postgres', password: 'okad', useSSL: false);
    try {
      await conn.open();
      final columnsString = columns.entries
          .map((entry) => '${entry.key} ${entry.value}')
          .join(', ');
      await conn.execute('''
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
