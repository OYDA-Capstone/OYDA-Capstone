// ignore_for_file: unused_field, avoid_print

library oydagrest;

import 'package:http/http.dart' as http;

class Oydagrest {
  static String? _baseUrl;
  static String? _devKey;

  static void setBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
  }

  static void unsetBaseUrl() {
    _baseUrl = null;
  }

  static void setDevKey(String key) {
    _devKey = key;
  }

  static void unsetDevKey() {
    _devKey = null;
  }

  Future<void> setOydabase(String? key, String baseUrl) async {
    // Check if the dev key is set
    if (key == null) {
      throw Exception('Developer Key is required to access the oydabase.');
    } else {
      // Check if the postgrest api is up and connected to the oydabase
      try {
        final uri = Uri.parse(baseUrl);
        final response = await http.head(uri);
        if (response.statusCode == 200) {
          print('Oydabase set @ $baseUrl');
          setBaseUrl(baseUrl);
        } else {
          throw Exception('Error connecting to the oydabase @ $baseUrl. Status code: ${response.statusCode}');
        }
      } on FormatException catch (e) {
        throw Exception('Invalid base URL format: $e');
      } on http.ClientException catch (e) {
        throw Exception('Error checking base URL: $e');
      }
    }
  }

  Future<void> unsetOydabase() async {
    unsetBaseUrl();
    unsetDevKey();
    print('Oydabase dropped successfully');
  }
}
