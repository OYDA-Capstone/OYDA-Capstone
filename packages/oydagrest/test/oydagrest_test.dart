import 'package:flutter_test/flutter_test.dart';
import 'package:oydagrest/src/oydagrest.dart';

void main() {

  String devKey = "777333";
  String baseUrl = "http://localhost:3000/";
  // String baseUrl = "oyda.database.windows.net";

  group('Oydagrest', () {

    test('setOydabase', () async {
      final oydaInterface = Oydagrest();
      await oydaInterface.setOydabase(devKey, baseUrl);
    });

    test('unsetOydabase', () async {
      final oydaInterface = Oydagrest();
      await oydaInterface.unsetOydabase();
    });


  });


}
