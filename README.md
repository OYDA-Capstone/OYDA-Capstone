# OYDA-db
The `oydadb` package provides a simple and efficient way to interact with PostgreSQL databases from your Flutter applications. It encapsulates all the necessary database operations in the `OYDAInterface` class, making it easier to perform CRUD operations.

## Getting Started

First, add the `oydadb` package to your `pubspec.yaml` file:

```yaml
dependencies:
  oydadb: ^0.0.1
```

Then, run flutter pub get to fetch the package.

## Usage

Import the package in your Dart file:

```dart
import 'package:oydadb/oydadb.dart';
```

Create an instance of the `OYDAInterface` class:

```dart
final oydaInterface = OYDAInterface();
```

Set up the database connection:

```dart
await oydaInterface.setOydaBase(devKey, oydabaseName, host, port, username, password, useSSL);
```

Please replace the placeholders with your actual values and add more details as necessary.


Now, you can use the `oydaInterface` instance to interact with your PostgreSQL database. For example to create a table: 

```dart
const tableName = 'test_table';
final columns = {
  'id': 'SERIAL PRIMARY KEY',
  'name': 'VARCHAR(255)',
  'age': 'INTEGER',
};
await oydaInterface.createTable(tableName, columns);
```

## Testing

Tests are located in the `test/` directory. To run them, use the flutter test command.

## License

This package is licensed under the MIT License. See the `LICENSE` file for more information
