# OYDA Interface

The OYDA Interface is a comprehensive solution designed to enable independent collaborative development. The first step towards this goal is the introduction of the `oydadb` package, a powerful tool that simplifies interactions with PostgreSQL databases in Flutter applications. It encapsulates all necessary database operations within the `OYDAInterface` class, making it easier to perform CRUD operations.

## Getting Started

First, add the `oydadb` package to your `pubspec.yaml` file:

```yaml
dependencies:
  oydadb: ^1.0.0
```

Then, run `flutter pub get` to fetch the package.

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

Now, you can use the `oydaInterface` instance to interact with your PostgreSQL database. For example, to create a table:

```dart
const tableName = 'test_table';
final columns = {
  'id': 'SERIAL PRIMARY KEY',
  'name': 'VARCHAR(255)',
  'age': 'INTEGER',
};
await oydaInterface.createTable(tableName, columns);
```

This first version of the OYDA Interface, featuring the `oydadb` package, is a significant step towards making database operations in Flutter applications more straightforward and efficient, and enabling independent collaborative development.