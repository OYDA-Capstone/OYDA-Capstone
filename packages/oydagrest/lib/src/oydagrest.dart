// ignore_for_file: unused_field, avoid_print

library oydagrest;
import 'package:http/http.dart' as http;

/// This class provides an interface for web applications to interact with Oydabases through the PostgREST API.
/// The given Oydabase must be exposed through the PostgREST API by setting a configuration file and running
/// the PostgREST server.
class Oydagrest {
  /// The base URL of the Oydabase.
  static String? _baseUrl;

  /// The developer key used to control developer access to different tables in the Oydabase.
  static String? _devKey;

  /// Sets the base URL of the Oydabase, allowing for interaction with the Oydabase.
  /// * [baseUrl] specifies the base URL of the Oydabase.
  static void setBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
  }

  /// Unsets the base URL of the Oydabase, preventing further interaction with the Oydabase.
  static void unsetBaseUrl() {
    _baseUrl = null;
  }

  /// Sets the developer key used to control developer access to different tables in the Oydabase.
  /// * [key] specifies the developer key required to access the OydaBase.
  static void setDevKey(String key) {
    _devKey = key;
  }

  /// Unsets the developer key, preventing further access to the Oydabase.
  static void unsetDevKey() {
    _devKey = null;
  }

  /// Sets the Oydabase to interact with using the given developer key and base URL.
  /// * [key] specifies the developer key required to access the Oydabase.
  /// * [baseUrl] specifies the base URL of the Oydabase.
  /// * Throws an [Exception] if the developer key is not set or if there is an error connecting to the Oydabase.
  ///
  /// Example:
  /// ```dart
  /// final oydaInterface = Oydagrest();
  /// await oydaInterface.setOydabase(baseUrl);
  /// ```
  Future<void> setOydabase(String? key, String baseUrl) async {
    // Check if the developer key is set
    if (key == null) {
      throw Exception('Developer Key is required to access the oydabase.');
    } else {
      // Check if the postgrest api is up and connected to the oydabase
      try {
        // Check if the base URL is valid
        final uri = Uri.parse(baseUrl);

        // Check if the base URL is reachable
        final response = await http.head(uri);
        if (response.statusCode == 200) {
          setBaseUrl(baseUrl);
          print('Oydabase set @$baseUrl');
          setDevKey(key);
        } else {
          throw Exception('Error connecting to the oydabase @$baseUrl. Status code: ${response.statusCode}');
        }
      } on FormatException catch (e) {
        throw Exception('Invalid base URL format: $e');
      } on http.ClientException catch (e) {
        throw Exception('Error checking base URL: $e');
      }
    }
  }

  /// Unsets the Oydabase, preventing further interaction with the Oydabase.
  Future<void> unsetOydabase() async {
    if (_baseUrl == null) {
      throw Exception('Oydabase is not set');
    }
    unsetBaseUrl();
    print('Oydabase dropped successfully');
    unsetDevKey();
  }
}

Future<void> createTable(String tableName){}
