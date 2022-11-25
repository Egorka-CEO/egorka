import 'package:dio/dio.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/model/address.dart';
import 'package:egorka/model/coast_advanced.dart';
import 'package:egorka/model/coast_base.dart';
import 'package:egorka/model/marketplaces.dart' as mrkt;

class Repository {
  var dio = Dio();

  Map<String, dynamic> auth() {
    return {
      "Type": "Application",
      "System": "Corp",
      "Key": "AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEEEE",
    };
  }

  Map<String, dynamic> params() {
    return {
      "Compress": "GZip",
      "Language": "RU",
    };
  }

  Options header() {
    return Options(
      headers: {
        'Content-Type': 'application/json',
      },
    );
  }

  Future<Address?> getAddress(String value) async {
    final response = await dio.post(
      '$server/dictionary/',
      options: header(),
      data: {
        "Auth": auth(),
        "Method": "Location",
        "Body": {
          "Query": value,
        },
        "Params": params()
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

  Future<mrkt.MarketPlaces?> getMarketplaces() async {
    final response = await dio.post(
      '$server/dictionary/',
      options: header(),
      data: {
        "Auth": auth(),
        "Method": "Marketplace",
        "Body": {},
        "Params": params()
      },
    );

    if (response.statusCode == 200) {
      try {
        final marketplace = mrkt.MarketPlaces.fromJson(response.data);
        return marketplace;
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<void> getCoastBase(CoastBase value) async {
    final body = value.toJson();
    final response = await dio.post(
      '$server/',
      options: header(),
      data: {
        "Auth": auth(),
        "Method": "Calculate",
        "Body": body,
        "Params": params()
      },
    );

    print('response base=${response.data}');
  }

  Future<void> getCoastAdvanced(CoastAdvanced value) async {
    final response = await dio.post(
      '$server/',
      options: header(),
      data: {
        "Auth": auth(),
        "Method": "Location",
        "Body": value.toJson(),
        "Params": params()
      },
    );

    print('response advanced=${response.data}');
  }

  Future<void> createForm() async {
    final response = await dio.post(
      '$server/',
      options: header(),
      data: {
        "Auth": auth(),
        "Method": "Create",
        "Body": {
          "ID": "5DD6960E9F0AE203C30CDE62",
        },
        "Params": auth()
      },
    );

    print('response createForm=${response.data}');
  }

  Future<void> infoForm() async {
    final response = await dio.post(
      '$server/',
      options: header(),
      data: {
        "Auth": auth(),
        "Method": "Check",
        "Body": {
          "RecordNumber": "100732",
          "RecordPIN": "6875",
        },
        "Params": auth()
      },
    );

    print('response infoForm=${response.data}');
  }

  Future<void> cancelForm() async {
    final response = await dio.post(
      '$server/',
      options: header(),
      data: {
        "Auth": auth(),
        "Method": "Cancel",
        "Body": {
          "RecordNumber": "100732",
          "RecordPIN": "6875",
        },
        "Params": auth()
      },
    );

    print('response cancelForm=${response.data}');
  }

  Future<void> paypentDeposit() async {
    var authData = auth();
    authData['Account'] = 'ZZZZZZZZ-ZZZZ-ZZZZ-ZZZZ-ZZZZZZZZZZZZ';

    final response = await dio.post(
      '$server/',
      options: header(),
      data: {"ID": 100217, "PIN": 4901, "Gate": "Account"},
    );

    print('response paypentDeposit=${response.data}');
  }

  Future<void> paypentCard() async {
    final response = await dio.post(
      '$server/',
      options: header(),
      data: {
        "Auth": auth(),
        "Method": "Redirect",
        "Body": {
          "ID": "100217",
          "PIN": "4901",
          "Gate": "Tinkoff",
          "Return": {
            "Success":
                "https://site.ru/order/view?Record=1007326875&Status=Success",
            "Failure":
                "https://site.ru/order/view?Record=1007326875&Status=Failure",
            "Pending":
                "https://site.ru/order/view?Record=1007326875&Status=Pending"
          }
        },
        "Params": auth()
      },
    );

    print('response paypentCard=${response.data}');
  }
}
