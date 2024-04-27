// ignore_for_file: unused_field

library oydagrest;

// ignore: unused_import
import 'package:http/http.dart';

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
    // check if the dev key is set
    if (key == null) {
      throw Exception('Developer Key is required to access the Oydabase.');
    } else {
      setBaseUrl(baseUrl);
    }
  }

  Future<void> unsetOydabase() async {}
}
