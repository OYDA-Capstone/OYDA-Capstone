# Release Notes for OYDA Interface

# v0.0.1
## Overview
The OYDA Interface is a comprehensive solution designed to enable independent collaborative development. The first step towards this goal is the introduction of the `oydadb` package, a powerful tool that simplifies interactions with PostgreSQL databases in Flutter applications. It provides a straightforward and efficient way to perform CRUD operations, encapsulating all necessary database operations within the `OYDAInterface` class.

## General

The `oydadb` package, as the first component of the OYDA Interface, offers a wide range of functionalities, including:

- **Database Connection Management**: The package includes a `ConnectionManager` class that handles the connection to the database. This class is used by the `OYDAInterface` to establish and manage the database connection.

- **Data Management**: The `DataManager` class is responsible for managing data operations. It provides methods for inserting rows into a table, selecting rows based on conditions, and more.

- **Table Management**: The `TableManager` class provides methods for creating and managing tables in the database.

- **Utilities**: The `Utilities` class provides helper methods for Oydabase operations, such as checking the developer key and the connection status.

- **Condition Management**: The `Condition` class allows you to create conditions for selecting rows from a table.

To use the `OYDAInterface`, simply create an instance of the class and use it to interact with your PostgreSQL database. For example, to create a table:

```dart
final oydaInterface = OYDAInterface();
await oydaInterface.setOydaBase(devKey, oydabaseName, host, port, username, password, useSSL);
const tableName = 'test_table';
final columns = {
  'id': 'SERIAL PRIMARY KEY',
  'name': 'VARCHAR(255)',
  'age': 'INTEGER',
};
await oydaInterface.createTable(tableName, columns);
```

This first version of the OYDA Interface, featuring the `oydadb` package, is a significant step towards making database operations in Flutter applications more straightforward and efficient, and enabling independent collaborative development.

---

# v0.0.2
## Overview
In this update, we've made some minor but important improvements to the `oydadb` package, part of the OYDA Interface. These changes are designed to enhance the usability of the `OYDAInterface` class and simplify table operations.

## General

The updates in this version include:

- **Persistent `OYDAInterface` Instances**: We've updated the `OYDAInterface` class so that an instance of `OYDAInterface` persists across all files. This change allows for more efficient use of the interface by ensuring all operations are associated with a single instance of the class.

- **Improved Table Operations**: We've made minor updates to the functions that manage table operations. These changes make data parsing easier, streamlining the process of working with table data.


These updates are part of our ongoing commitment to making the OYDA Interface more user-friendly and efficient. We appreciate your feedback and look forward to making further improvements in future updates.