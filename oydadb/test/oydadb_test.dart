import 'package:flutter_test/flutter_test.dart';

import 'package:oydadb/oydadb.dart';

void main() {
  // Test the OYDAInterface class
  String oydabaseName = 'oyda';
  String host = 'localhost';
  int port = 5400;
  String username = 'postgres';
  String password = 'okad';
  bool useSSL = false;

  group('OYDAInterface', () {
    test('setOydaBase', () async {
      final oydaInterface = OYDAInterface();
      await oydaInterface.setOydaBase(oydabaseName, host, port, username, password, useSSL);
    });

    test('doubleSetOydaBase', () async {
      final oydaInterface = OYDAInterface();
      await oydaInterface.setOydaBase(oydabaseName, host, port, username, password, useSSL);
      await oydaInterface.setOydaBase(oydabaseName, host, port, username, password, useSSL);
    });

    test('dropOydaBase', () async {
      final oydaInterface = OYDAInterface();
      await oydaInterface.setOydaBase(oydabaseName, host, port, username, password, useSSL);
      await oydaInterface.unsetOydabase();
    });

    test('createTable', () async {
      final oydaInterface = OYDAInterface();
      await oydaInterface.setOydaBase(oydabaseName, host, port, username, password, useSSL);

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
      await oydaInterface.setOydaBase(oydabaseName, host, port, username, password, useSSL);

      var table = await oydaInterface.selectTable('test_table');
      print(table);
    });

    test('dropTable', () async {
      final oydaInterface = OYDAInterface();
      await oydaInterface.setOydaBase(oydabaseName, host, port, username, password, useSSL);

      const tableName = 'test_table';
      final columns = {
        'id': 'SERIAL PRIMARY KEY',
        'name': 'VARCHAR(255)',
        'age': 'INTEGER',
      };
      await oydaInterface.createTable(tableName, columns);

      var table1 = await oydaInterface.selectTable('test_table');
      print(table1);

      await oydaInterface.dropTable('test_table');

      // uncomment this to test
      // var table2 = await oydaInterface.selectTable('test_table');
      // print(table2);
    });



  });
}
