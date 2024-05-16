import 'package:oydadb/oydadb.dart';

/// A utility class that provides helper methods for Oydabase operations.
class Utilities {
  /// The [ConnectionManager] instance responsible for managing the connection to the database.
  final ConnectionManager connectionManager;

  /// Creates an instance of the `Utilities` class with the specified `connectionManager`.
  Utilities(this.connectionManager);

  /// Checks if the developer key is set.
  ///
  /// Throws an exception if the developer key is not set.
  void checkDevKey() {
    if (connectionManager.devKey == null) {
      throw Exception('Developer Key is required to access Oydabase.');
    }
  }

  /// Checks if the connection is set.
  ///
  /// Throws an exception if the connection is not set.
  void checkConnection() {
    if (connectionManager.connection == null) {
      throw Exception('Oydabase not set. Please call setOydaBase() first.');
    }
  }
}
