import 'package:dio/dio.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/model/address.dart';

class Repository {
  var dio = Dio();

  Future<Address?> getAddress(String value) async {
    final response = await dio.post(
      '$server/dictionary/',
      options: Options(headers: {
        'Content-Type': 'application/json',
      }),
      data: {
        "Auth": {
          "Type": "Application",
          "System": "Agent",
          "Key": "AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEEEE",
        },
        "Method": "Location",
        "Body": {
          "Query": value,
        },
        "Params": {
          "Compress": "GZip",
          "Language": "RU",
        }
      },
    );

    if (response.statusCode == 200) {
      try {
        final address = Address.fromJson(response.data);
        if (address.errors == null) {
          return Address.fromJson(response.data);
        }
      } catch (e) {
        return null;
      }
      return null;
    } else {
      return null;
    }
  }
}
