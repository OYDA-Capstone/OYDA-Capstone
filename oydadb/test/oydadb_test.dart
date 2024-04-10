import 'package:flutter_test/flutter_test.dart';

import 'package:oydadb/oydadb.dart';

void main() {
  // Test the OYDAInterface class
  group('OYDAInterface', () {
    final oydaInterface = OYDAInterface();

    test('createTable', () async {
      final tableName = 'test_table';
      final columns = {
        'id': 'SERIAL PRIMARY KEY',
        'name': 'VARCHAR(255)',
        'age': 'INTEGER',
      };
      await oydaInterface.createTable(tableName, columns);
    });

    
  });
}
