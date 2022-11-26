import 'package:dio/dio.dart';
import 'package:egorka/core/database/secure_storage.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/model/address.dart';
import 'package:egorka/model/coast_advanced.dart';
import 'package:egorka/model/coast_base.dart';
import 'package:egorka/model/marketplaces.dart' as mrkt;
import 'package:egorka/model/payment.dart';
import 'package:get_ip_address/get_ip_address.dart';

class Repository {
  var dio = Dio();

  String IP = '';

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

  Future<void> getIP() async {
    var ipAddress = IpAddress(type: RequestType.json);
    dynamic data = await ipAddress.getIpAddress();

    IP = data['ip'];
  }

  Future<Address?> getAddress(String value) async {
    final response = await dio.post(
      '$server/delivery/dictionary/',
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
      '$server/delivery/dictionary/',
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
      '$server/delivery/',
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

  Future<void> createForm(String value) async {
    final response = await dio.post(
      '$server/delivery/',
      options: header(),
      data: {
        "Auth": auth(),
        "Method": "Create",
        "Body": {
          "ID": value,
        },
        "Params": params()
      },
    );

    print('response createForm=${response.data}');
  }

  Future<void> infoForm(String number, String pin) async {
    final response = await dio.post(
      '$server/delivery/',
      options: header(),
      data: {
        "Auth": auth(),
        "Method": "Check",
        "Body": {
          "RecordNumber": number,
          "RecordPIN": pin,
        },
        "Params": params()
      },
    );

    print('response infoForm=${response.data}');
  }

  Future<void> cancelForm(String number, String pin) async {
    final response = await dio.post(
      '$server/delivery/',
      options: header(),
      data: {
        "Auth": auth(),
        "Method": "Cancel",
        "Body": {
          "RecordNumber": number,
          "RecordPIN": pin,
        },
        "Params": params()
      },
    );

    print('response cancelForm=${response.data}');
  }

  Future<void> paymentDeposit(int id, int pin) async {
    var authData = auth();
    authData['Account'] = 'ZZZZZZZZ-ZZZZ-ZZZZ-ZZZZ-ZZZZZZZZZZZZ';

    final response = await dio.post(
      '$server/delivery/',
      options: header(),
      data: {
        "ID": id,
        "PIN": pin,
        "Gate": "Account",
      },
    );

    print('response paymentDeposit=${response.data}');
  }

  Future<void> paymentCard(Payment payment) async {
    final response = await dio.post(
      '$server/delivery/',
      options: header(),
      data: {
        "Auth": auth(),
        "Method": "Redirect",
        "Body": {
          "ID": payment.iD,
          "PIN": payment.pIN,
          "Gate": payment.gate,
          "Return": payment.answer,
        },
        "Params": params()
      },
    );

    print('response paymentCard=${response.data}');
  }

  //Авторизация Пользователь

  Future<void> UUUIDCreate() async {
    var authData = auth();
    await getIP();
    authData['UserIP'] = IP;
    authData['UserUUID'] = '';

    final response = await dio.post(
      '$server/auth/user/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "UUIDCreate",
        "Body": {},
        "Params": params()
      },
    );

    if (response.data['Errors'] == null) {
      MySecureStorage().setID(response.data['Result']['ID']);
      MySecureStorage().setSecure(response.data['Result']['ID']);
    }

    print('response UUUIDCreate=${response.data}');
  }

  Future<void> UUUIDRegister(String value) async {
    var authData = auth();
    authData['UserIP'] = IP;
    authData['UserUUID'] = '';

    final response = await dio.post(
      '$server/auth/user/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "UUIDRegister",
        "Body": {
          "ID": value,
        },
        "Params": params()
      },
    );

    print('response UUUIDRegister=${response.data}');
  }

  Future<void> loginUsernameUser(String login, String password) async {
    var authData = auth();
    authData['UserIP'] = IP;
    authData['UserUUID'] = '';

    final response = await dio.post(
      '$server/auth/user/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Login",
        "Body": {
          "Username": login,
          "Password": password,
        },
        "Params": params()
      },
    );

    print('response loginUsernameUsers=${response.data}');
  }

  Future<void> loginEmailUser(String login, String password) async {
    var authData = auth();
    authData['UserIP'] = IP;
    authData['UserUUID'] = '';

    final response = await dio.post(
      '$server/auth/user/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Login",
        "Body": {
          "Email": login,
          "Password": password,
        },
        "Params": params()
      },
    );

    print('response loginEmailUser=${response.data}');
  }

  Future<void> loginPhoneUser(String login, String password) async {
    var authData = auth();
    authData['UserIP'] = IP;
    authData['UserUUID'] = '';

    final response = await dio.post(
      '$server/auth/user/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Login",
        "Body": {
          "Phone": login,
          "Password": password,
        },
        "Params": params()
      },
    );

    print('response loginPhoneUser=${response.data}');
  }

  //Авторизация Субагент или Корпорат
  Future<void> loginUsernameAgent(
      String login, String password, String company) async {
    var authData = auth();
    authData['UserIP'] = IP;
    authData['UserUUID'] = '';

    final response = await dio.post(
      '$server/auth/agent/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Login",
        "Body": {
          "Type": "Agent",
          "Company": company,
          "Username": login,
          "Password": password,
        },
        "Params": params()
      },
    );

    print('response loginUsernameAgent=${response.data}');
  }

  Future<void> loginEmailAgent(
      String login, String password, String company) async {
    var authData = auth();
    authData['UserIP'] = IP;
    authData['UserUUID'] = '';

    final response = await dio.post(
      '$server/auth/agent/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Login",
        "Body": {
          "Type": "Agent",
          "Company": login,
          "Email": login,
          "Password": password,
        },
        "Params": params()
      },
    );

    print('response loginEmailAgent=${response.data}');
  }

  Future<void> loginPhoneAgent(
      String login, String password, String company) async {
    var authData = auth();
    authData['UserIP'] = IP;
    authData['UserUUID'] = '';

    final response = await dio.post(
      '$server/auth/agent/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Login",
        "Body": {
          "Type": "Agent",
          "Company": company,
          "Phone": login,
          "Password": password,
        },
        "Params": params()
      },
    );

    print('response loginPhoneAgent=${response.data}');
  }
}
