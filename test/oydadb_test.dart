// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:oydadb/oydadb.dart';

void main() {
  // Test the OYDAInterface class
  String host = 'oydaserver.postgres.database.azure.com';
  String oydabaseName = 'oydadb';
  String username = 'oydaadmin';
  String password = 'OhenebaOmar123';
  String devKey = "77775432";
  bool useSSL = true;
  int port = 5432;

  group('OYDAInterface', () {
    test('setOydaBase', () async {
      final oydaInterface = OYDAInterface();
      await oydaInterface.setOydaBase(devKey, oydabaseName, host, port, username, password, useSSL);
    });

    test('doubleSetOydaBase', () async {
      final oydaInterface = OYDAInterface();
      await oydaInterface.setOydaBase(devKey, oydabaseName, host, port, username, password, useSSL);
      await oydaInterface.setOydaBase(devKey, oydabaseName, host, port, username, password, useSSL);
    });

    test('unsetOydaBase', () async {
      final oydaInterface = OYDAInterface();
      await oydaInterface.setOydaBase(devKey, oydabaseName, host, port, username, password, useSSL);
      await oydaInterface.unsetOydabase();
    });

    test('createTable', () async {
      final oydaInterface = OYDAInterface();
      await oydaInterface.setOydaBase(devKey, oydabaseName, host, port, username, password, useSSL);

      const tableName = 'test_table';
      final columns = {
        'id': 'SERIAL PRIMARY KEY',
        'name': 'VARCHAR(255)',
        'age': 'INTEGER',
      };
      await oydaInterface.createTable(tableName, columns);
    });

    test('doubleCreateTable', () async {
      final oydaInterface = OYDAInterface();
      await oydaInterface.setOydaBase(devKey, oydabaseName, host, port, username, password, useSSL);

      const tableName = 'test_table';
      final columns = {
        'id': 'SERIAL PRIMARY KEY',
        'name': 'VARCHAR(255)',
        'age': 'INTEGER',
      };
      await oydaInterface.createTable(tableName, columns);
      await oydaInterface.insertRows('test_table', {'name': 'Oheneba', 'age': '18'});
      await oydaInterface.createTable(tableName, columns);
      await oydaInterface.insertRows('test_table', {'name': 'Oheneba', 'age': '25'});
    });

    test('insertRow', () async {
      final oydaInterface = OYDAInterface();
      await oydaInterface.setOydaBase(devKey, oydabaseName, host, port, username, password, useSSL);

      const tableName = 'test_table';
      final columns = {
        'id': 'SERIAL PRIMARY KEY',
        'name': 'VARCHAR(255)',
        'age': 'INTEGER',
      };
      await oydaInterface.createTable(tableName, columns);
      await oydaInterface.insertRows('test_table', {'name': 'Oheneba', 'age': '18'});
      await oydaInterface.insertRows('test_table', {'name': 'Omar', 'age': '200'});
    });

    test('selectTable', () async {
      final oydaInterface = OYDAInterface();
      await oydaInterface.setOydaBase(devKey, oydabaseName, host, port, username, password, useSSL);

      const tableName = 'test_table';
      final columns = {
        'id': 'SERIAL PRIMARY KEY',
        'name': 'VARCHAR(255)',
        'age': 'INTEGER',
      };
      await oydaInterface.createTable(tableName, columns);

      var table = await oydaInterface.selectTable('test_table');
      print(table);
    });

    test('selectRows', () async {
      final oydaInterface = OYDAInterface();
      await oydaInterface.setOydaBase(devKey, oydabaseName, host, port, username, password, useSSL);

      const tableName = 'test_table';
      final columns = {
        'id': 'SERIAL PRIMARY KEY',
        'name': 'VARCHAR(255)',
        'age': 'INTEGER',
      };
      await oydaInterface.createTable(tableName, columns);

      var rows = await oydaInterface.selectRows('test_table', [Condition('name', '=', 'Oheneba')]);
      print(rows);
    });

    test('selectColumns', () async {
      final oydaInterface = OYDAInterface();
      await oydaInterface.setOydaBase(devKey, oydabaseName, host, port, username, password, useSSL);

      const tableName = 'test_table';
      final columns = {
        'id': 'SERIAL PRIMARY KEY',
        'name': 'VARCHAR(255)',
        'age': 'INTEGER',
      };
      await oydaInterface.createTable(tableName, columns);

      var columns1 = await oydaInterface.selectColumns('test_table', ['name', 'age']);
      print(columns1);

      var columns2 =
          await oydaInterface.selectColumns('test_table', ['name', 'age'], [Condition('name', '=', 'Oheneba')]);
      print(columns2);

      var columns3 = await oydaInterface.selectColumns('test_table', ['age'], [Condition('name', '=', 'Oheneba')]);
      print(columns3);
    });
  });

  test('dropTable', () async {
    final oydaInterface = OYDAInterface();
    await oydaInterface.setOydaBase(devKey, oydabaseName, host, port, username, password, useSSL);

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
}
