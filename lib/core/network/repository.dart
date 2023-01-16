import 'dart:io';
import 'package:dio/dio.dart';
import 'package:egorka/core/database/secure_storage.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/model/account_deposit.dart';
import 'package:egorka/model/address.dart';
import 'package:egorka/model/coast_advanced.dart';
import 'package:egorka/model/coast_base.dart';
import 'package:egorka/model/coast_marketplace.dart';
import 'package:egorka/model/create_form_model.dart' as crtForm;
import 'package:egorka/model/create_form_model.dart';
import 'package:egorka/model/filter_invoice.dart';
import 'package:egorka/model/info_form.dart';
import 'package:egorka/model/invoice.dart';
import 'package:egorka/model/marketplaces.dart';
import 'package:egorka/model/payment_card.dart';
import 'package:egorka/model/response_coast_base.dart';
import 'package:egorka/model/user.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Repository {
  var dio = Dio();

  String key = '';
  String IP = '';

  Future<Map<String, dynamic>> auth() async {
    key = await MySecureStorage().getID() ?? '';
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
    var authData = await auth();
    final response = await dio.post(
      '$server/service/delivery/dictionary/',
      options: header(),
      data: {
        "Auth": authData,
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
        return address;
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<MarketPlaces?> getMarketplaces() async {
    var authData = await auth();
    final response = await dio.post(
      '$server/service/delivery/dictionary/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Marketplace",
        "Body": {},
        "Params": params()
      },
    );

    if (response.statusCode == 200) {
      try {
        final marketplace = MarketPlaces.fromJson(response.data);
        return marketplace;
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<CoastResponse?> getCoastBase(CoastBase value) async {
    final body = value.toJson();
    var authData = await auth();
    final response = await dio.post(
      '$server/service/delivery/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Calculate",
        "Body": body,
        "Params": params()
      },
    );

    if (response.data['Result'] != null) {
      final coast = CoastResponse.fromJson(response.data);
      return coast;
    }
    return null;
  }

  Future<CoastResponse?> getCoastMarketPlace(CoastMarketPlace value) async {
    final body = value.toJson();
    print('object ${body}');
    var authData = await auth();
    final response = await dio.post(
      '$server/service/delivery/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Calculate",
        "Body": body,
        "Params": params()
      },
    );

    if (response.data['Result'] != null) {
      final coast = CoastResponse.fromJson(response.data);
      return coast;
    }
    return null;
  }

  Future<CoastResponse?> getCoastAdvanced(CoastAdvanced value) async {
    final body = value.toJson();
    var authData = await auth();
    final response = await dio.post(
      '$server/service/delivery/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Calculate",
        "Body": body,
        "Params": params()
      },
    );

    if (response.data['Result'] != null) {
      final coast = CoastResponse.fromJson(response.data);
      return coast;
    }
    return null;
  }

  Future<crtForm.CreateFormModel?> createForm(String value) async {
    var authData = await auth();
    final response = await dio.post(
      '$server/service/delivery/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Create",
        "Body": {
          "ID": value,
        },
        "Params": params()
      },
    );

    if (response.data['Result'] != null) {
      final createForm = crtForm.CreateFormModel.fromJson(response.data);
      return createForm;
    }

    return null;
  }

  Future<List<crtForm.CreateFormModel>?> getListForm() async {
    var authData = await auth();
    final response = await dio.post(
      '$server/service/delivery/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Orders",
        "Body": {
          "Limit": 50,
          "Offset": 0,
        },
        "Params": {"Language": "RU"}
      },
    );

    if (response.data['Result'] != null) {
      List<CreateFormModel> list = [];
      for (var element in response.data['Result']['Orders']) {
        list.add(crtForm.CreateFormModel(
            time: null,
            timeStamp: null,
            execution: null,
            method: null,
            errors: null,
            result: crtForm.Result.fromJson(element)));
      }
      return list;
    }

    return null;
  }

  Future<InfoForm?> infoForm(String recordNumber, String recordPin) async {
    var authData = await auth();
    final response = await dio.post(
      '$server/service/delivery/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Check",
        "Body": {
          "RecordNumber": recordNumber,
          "RecordPIN": recordPin,
        },
        "Params": params()
      },
    );

    if (response.data['Result'] != null) {
      final res = InfoForm.fromJson(response.data);
      return res;
    }
    return null;
  }

  Future<bool> cancelForm(String number, String pin) async {
    var authData = await auth();
    final response = await dio.post(
      '$server/service/delivery/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Cancel",
        "Body": {
          "RecordNumber": number,
          "RecordPIN": pin,
        },
        "Params": params()
      },
    );

    if (response.data['Errors'] == null) {
      return true;
    }

    return false;
  }

  Future<String?> paymentDeposit(int id, int pin, String key) async {
    var authData = await auth();
    authData['Account'] = key;

    final response = await dio.post(
      '$server/service/payment/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Request",
        "Body": {
          "ID": id,
          "PIN": pin,
          "Gate": "Account",
        },
        "Params": params()
      },
    );

    if (response.data['Errors'] == null) {
      return null;
    } else {
      return response.data['Errors'][0]['Message'];
    }
  }

  Future<PaymentCard?> paymentCard(int id, int pin) async {
    var authData = await auth();
    final response = await dio.post(
      '$server/service/payment/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Redirect",
        "Body": {
          "ID": id,
          "PIN": pin,
          "Gate": "Tinkoff",
          "Logic": "Card",
        },
        "Params": params()
      },
    );

    if (response.data['Result'] != null) {
      PaymentCard? res = PaymentCard.fromJson(response.data['Result']);
      return res;
    }
    return null;
  }

  //Авторизация Пользователь

  Future<bool> UUIDCreate() async {
    var authData = await auth();
    await getIP();
    authData['UserIP'] = IP;
    authData['UserUUID'] = '';

    final response = await dio.post(
      '$server/service/auth/user/',
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
      MySecureStorage().setSecure(response.data['Result']['Secure']);
      UUIDRegister(response.data['Result']['ID']);
      return true;
    }

    return false;
  }

  Future<void> UUIDRegister(String value) async {
    var authData = await auth();
    authData['UserIP'] = IP;
    authData['UserUUID'] = '';

    final response = await dio.post(
      '$server/service/auth/user/',
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
  }

  Future<AuthUser?> loginUsernameUser(String login, String password) async {
    var authData = await auth();
    authData['UserIP'] = IP;
    authData['UserUUID'] = '';

    final response = await dio.post(
      '$server/service/auth/user/',
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

    if (response.data['Errors'] == null) {
      final user = AuthUser.fromJson(response.data);
      return user;
    } else {
      return null;
    }
  }

  Future<AuthUser?> loginEmailUser(String login, String password) async {
    var authData = await auth();
    authData['UserIP'] = IP;
    authData['UserUUID'] = '';

    final response = await dio.post(
      '$server/service/auth/user/',
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

    if (response.data['Errors'] == null) {
      final user = AuthUser.fromJson(response.data);
      return user;
    } else {
      return null;
    }
  }

  Future<AuthUser?> loginPhoneUser(String login, String password) async {
    var authData = await auth();
    authData['UserIP'] = IP;
    authData['UserUUID'] = '';

    final response = await dio.post(
      '$server/service/auth/user/',
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

    if (response.data['Errors'] == null) {
      final user = AuthUser.fromJson(response.data);
      return user;
    } else {
      return null;
    }
  }

  //Авторизация Субагент или Корпорат
  Future<AuthUser?> loginUsernameAgent(
      String login, String password, String company) async {
    var authData = await auth();
    authData['UserIP'] = IP;
    authData['UserUUID'] = '';

    final response = await dio.post(
      '$server/service/auth/agent/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Login",
        "Body": {
          "Type": "Corp",
          "Company": company,
          "Username": login,
          "Password": password,
        },
        "Params": params()
      },
    );

    if (response.data['Errors'] == null) {
      final user = AuthUser.fromJson(response.data);
      return user;
    } else {
      return null;
    }
  }

  Future<AuthUser?> loginEmailAgent(
      String login, String password, String company) async {
    var authData = await auth();
    authData['UserIP'] = IP;
    authData['UserUUID'] = '';

    final response = await dio.post(
      '$server/service/auth/agent/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Login",
        "Body": {
          "Type": "Agent",
          "Company": company,
          "Email": login,
          "Password": password,
        },
        "Params": params()
      },
    );

    if (response.data['Errors'] == null) {
      final user = AuthUser.fromJson(response.data);
      return user;
    } else {
      return null;
    }
  }

  Future<AuthUser?> loginPhoneAgent(
      String login, String password, String company) async {
    var authData = await auth();
    authData['UserIP'] = IP;
    authData['UserUUID'] = '';

    final response = await dio.post(
      '$server/service/auth/agent/',
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

    if (response.data['Errors'] == null) {
      final user = AuthUser.fromJson(response.data);
      return user;
    } else {
      return null;
    }
  }

  // депозит
  Future<AccountsDeposit?> getDeposit() async {
    var authData = await auth();
    final response = await dio.post(
      '$server/service/account/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Details",
        "Body": {},
        "Params": params()
      },
    );

    if (response.data['Errors'] == null) {
      final user = AccountsDeposit.fromJson(response.data);
      return user;
    } else {
      return null;
    }
  }

  Future<Invoice?> createInvoice(int value) async {
    var authData = await auth();
    final response = await dio.post(
      '$server/service/invoice/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Create",
        "Body": {
          "Amount": value,
          "Currency": "RUB",
        },
        "Params": params()
      },
    );

    if (response.data['Result'] != null) {
      final invoice = InvoiceModel.fromJson(response.data);
      return invoice.result?.invoice;
    } else {
      return null;
    }
  }

  Future<List<Invoice>?> getInvoiceFilter(Filter filter) async {
    final fltr = filter.toJson();
    var authData = await auth();
    final response = await dio.post(
      '$server/service/invoice/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "List",
        "Body": {
          "Filter": fltr,
          "Limit": 50,
          "Offset": 0,
        },
        "Params": {"Language": "RU"}
      },
    );

    if (response.data['Result'] != null) {
      List<Invoice> list = [];
      for (var element in response.data['Result']['Invoices']) {
        list.add(Invoice.fromJson(element));
      }
      return list;
    } else {
      return null;
    }
  }

  Future<String> getPDF(int id, int pin) async {
    String savePath = await getFilePath('$id$pin.pdf');
    final response = await dio.get(
      '$server/export/invoice/pdf/?ID=$id$pin',
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
      ),
    );

    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    if (statuses[Permission.storage]!.isGranted) {
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
    }

    return savePath;
  }

  Future<String> getEXCEL(int id, int pin) async {
    String savePath = await getFilePath('$id$pin.xlsx');
    final response = await dio.get(
      '$server/export/invoice/excel/?ID=$id$pin',
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
      ),
    );

    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    if (statuses[Permission.storage]!.isGranted) {
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
    }

    return savePath;
  }

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';

    Directory? dir;
    if (Platform.isAndroid) {
      dir = (await getExternalStorageDirectories(
              type: StorageDirectory.downloads))
          ?.first;
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    path = '${dir!.path}/$uniqueFileName';

    return path;
  }
}
