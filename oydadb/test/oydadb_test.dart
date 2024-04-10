import 'package:flutter_test/flutter_test.dart';

import 'package:oydadb/oydadb.dart';

void main() {
  // Test the OYDAInterface class
  group('OYDAInterface', () {
    test('setOydaBase', () async {
      final oydaInterface = OYDAInterface();
      await oydaInterface.setOydaBase('oyda', 'localhost', 5400, 'postgres', 'okad', false);
    });

    test('doubleSetOydaBase', () async {
      final oydaInterface = OYDAInterface();
      await oydaInterface.setOydaBase('oyda', 'localhost', 5400, 'postgres', 'okad', false);
      await oydaInterface.setOydaBase('oyda', 'localhost', 5400, 'postgres', 'okad', false);
    });

    test('dropOydaBase', () async {
      final oydaInterface = OYDAInterface();
      await oydaInterface.setOydaBase('oyda', 'localhost', 5400, 'postgres', 'okad', false);
      await oydaInterface.unsetOydabase();
    });

    test('createTable', () async {
      final oydaInterface = OYDAInterface();
      await oydaInterface.setOydaBase('oyda', 'localhost', 5400, 'postgres', 'okad', false);

      const tableName = 'test_table';
      final columns = {
        'id': 'SERIAL PRIMARY KEY',
        'name': 'VARCHAR(255)',
        'age': 'INTEGER',
      };
      await oydaInterface.createTable(tableName, columns);
    });

    test('selectTable', () async {
      final oydaInterface = OYDAInterface();
      await oydaInterface.setOydaBase('oyda', 'localhost', 5400, 'postgres', 'okad', false);

      var table = await oydaInterface.selectTable('test_table');
      print(table);
    });
  });
}
