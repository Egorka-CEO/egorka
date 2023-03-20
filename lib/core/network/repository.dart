import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:egorka/core/database/secure_storage.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/model/account_deposit.dart';
import 'package:egorka/model/address.dart';
import 'package:egorka/model/book_adresses.dart';
import 'package:egorka/model/coast_advanced.dart';
import 'package:egorka/model/coast_base.dart';
import 'package:egorka/model/coast_marketplace.dart';
import 'package:egorka/model/create_form_model.dart' as crtForm;
import 'package:egorka/model/create_form_model.dart';
import 'package:egorka/model/employee.dart';
import 'package:egorka/model/filter_invoice.dart';
import 'package:egorka/model/info_form.dart';
import 'package:egorka/model/invoice.dart';
import 'package:egorka/model/marketplaces.dart';
import 'package:egorka/model/payment_card.dart';
import 'package:egorka/model/register_company.dart';
import 'package:egorka/model/register_user.dart';
import 'package:egorka/model/response_coast_base.dart';
import 'package:egorka/model/user.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Repository {
  var dio = Dio();

  String id = '';
  String key = '';
  String IP = '';

  Future<Map<String, dynamic>> auth({bool sessionKey = false}) async {
    id = await MySecureStorage().getID() ?? '';
    key = await MySecureStorage().getKey() ?? '';
    String typeDevice = Platform.isAndroid ? 'Android' : 'Apple';
    Map<String, dynamic> data = {
      "Type": typeDevice,
      "UserUUID": id,
    };
    if (key.isNotEmpty) data['Session'] = key;

    return data;
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
    var authData = await auth(sessionKey: true);
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
    var authData = await auth(sessionKey: true);
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
    var authData = await auth(sessionKey: true);
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

    log('message ${response.data['Result']}');

    if (response.data['Result'] != null) {
      final coast = CoastResponse.fromJson(response.data);
      return coast;
    }
    return null;
  }

  Future<crtForm.CreateFormModel?> createForm(String value) async {
    var authData = await auth(sessionKey: true);
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
    var authData = await auth(sessionKey: true);
    Map<String, dynamic> data = {
      "Auth": authData,
      "Method": "Orders",
      "Body": {
        "Limit": 50,
        "Offset": 0,
      },
      "Params": {"Language": "RU"}
    };
    final response = await dio.post(
      '$server/service/delivery/',
      options: header(),
      data: data,
    );

    if (response.data == '' || response.data['Result'] != null) {
      List<CreateFormModel> list = [];
      if (response.data != '') {
        for (var element in response.data['Result']['Orders']) {
          list.add(crtForm.CreateFormModel(
              time: null,
              timeStamp: null,
              execution: null,
              method: null,
              errors: null,
              result: crtForm.Result.fromJson(element)));
        }
      }
      return list;
    }

    return null;
  }

  Future<InfoForm?> infoForm(String recordNumber, String recordPin) async {
    var authData = await auth(sessionKey: true);
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
    var authData = await auth(sessionKey: true);
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
    Map<String, dynamic> data = {
      "Auth": authData,
      "Method": "Request",
      "Body": {
        "ID": id,
        "PIN": pin,
        "Gate": "Account",
      },
      "Params": params()
    };

    final response = await dio.post(
      '$server/service/payment/',
      options: header(),
      data: data,
    );

    if (response.data['Errors'] == null) {
      return null;
    } else {
      return response.data['Errors'][0]['Message'];
    }
  }

  Future<PaymentCard?> paymentCard(int id, int pin) async {
    var authData = await auth();
    Map<String, dynamic> data = {
      "ID": id,
      "PIN": pin,
      "Gate": "Tinkoff",
      "Logic": "Card",
    };
    final response = await dio.post(
      '$server/service/payment/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Redirect",
        "Body": data,
        "Params": params()
      },
    );

    if (response.data['Result'] != null) {
      PaymentCard? res = PaymentCard.fromJson(response.data['Result']);
      return res;
    }
    return null;
  }

  Future<bool> UUIDCreate() async {
    var authData = await auth();
    await getIP();

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
    var authData = await auth(sessionKey: true);

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

    final response = await dio.post(
      '$server/service/auth/user/',
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

    final user = AuthUser.fromJson(response.data);
    return user;
  }

  // Авторизация Субагент или Корпорат
  Future<AuthUser?> loginUsernameAgent(
      String login, String password, String company) async {
    var authData = await auth(sessionKey: true);

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

  Future<AccountsDeposit?> getDeposit() async {
    var authData = await auth(sessionKey: true);
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

    if (response.data == '') {
      return null;
    } else if (response.data['Errors'] == null) {
      final user = AccountsDeposit.fromJson(response.data);
      return user;
    } else {
      return null;
    }
  }

  Future<Invoice?> createInvoice(int value) async {
    var authData = await auth(sessionKey: true);
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
    var authData = await auth(sessionKey: true);
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

  Future<String?> getPDF(int id, int pin) async {
    try {
      String savePath = await getFilePath('$id$pin.pdf');
      final response = await dio.get(
        '$server/export/invoice/pdf/?ID=$id$pin',
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );

      if (response.statusCode == 200) {
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
    } catch (e) {}

    return null;
  }

  Future<String?> getEXCEL(int id, int pin) async {
    try {
      String savePath = await getFilePath('$id$pin.xlsx');
      final response = await dio.get(
        '$server/export/invoice/excel/?ID=$id$pin',
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      if (response.statusCode == 200) {
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
    } catch (e) {}
    return null;
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

  Future<int?> registerUser(RegisterUserModel userModel) async {
    var authData = await auth();
    final response = await dio.post(
      '$server/service/auth/user/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Create",
        "Body": userModel.toJson(),
        "Params": {}
      },
    );

    if (response.data['Errors'] != null) {
      return response.data['Errors'][0]['Code'];
    } else {
      return null;
    }
  }

  Future<int?> registerCompany(RegisterCompanyModel companyModel) async {
    var authData = await auth();
    Map<String, dynamic> data = {
      "Auth": authData,
      "Method": "Create",
      "Body": companyModel.toJson(),
      "Params": {}
    };
    final response = await dio.post(
      '$server/service/auth/agent/',
      options: header(),
      data: data,
    );

    if (response.data['Errors'] != null) {
      return response.data['Errors'][0]['Code'];
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> searchINN(String inn) async {
    var authData = await auth(sessionKey: true);
    final response = await dio.post(
      '$server/service/auth/agent/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Inn",
        "Body": {
          "Inn": inn,
        },
        "Params": {}
      },
    );

    if (response.data['Result'] == null) {
      return {};
    } else {
      return response.data['Result']['Companies'][0];
    }
  }

  Future<List<BookAdresses>?> getListBookAdress() async {
    var authData = await auth(sessionKey: true);
    final response = await dio.post(
      '$server/service/delivery/address/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "List",
        "Body": {},
        "Params": {
          "Language": "RU",
        }
      },
    );

    if (response.data == '') {
      return null;
    } else if (response.data['Errors'] != null) {
      return null;
    } else {
      List<BookAdresses> list = [];
      for (var element in response.data['Result']['Addresses']) {
        list.add(BookAdresses.fromJson(element));
      }
      return list;
    }
  }

  Future<bool> deleteAddress(String id) async {
    var authData = await auth(sessionKey: true);
    final response = await dio.post(
      '$server/service/delivery/address/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Remove",
        "Body": {
          "ID": id,
        },
        "Params": {
          "Language": "RU",
        }
      },
    );

    if (response.data['Errors'] != null) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> addAddress(BookAdresses bookAdresses) async {
    var authData = await auth(sessionKey: true);
    final response = await dio.post(
      '$server/service/delivery/address/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Add",
        "Body": bookAdresses.toJson(),
        "Params": {
          "Language": "RU",
        }
      },
    );

    log('message ${response.data}');

    if (response.data['Errors'] != null) {
      return false;
    } else {
      return true;
    }
  }

  Future<List<Employee>> getListEmployee() async {
    var authData = await auth();
    final response = await dio.post(
      '$server/service/auth/agent/',
      options: header(),
      data: {
        "Auth": authData,
        "Method": "Users",
        "Body": {},
        "Params": {},
      },
    );

    if (response.data['Errors'] == null) {
      List<Employee> employee = [];
      if (response.data != '') {
        for (var element in response.data['Result']['Users']) {
          employee.add(Employee.fromJson(element));
        }
      }
      return employee;
    } else {
      return [];
    }
  }

  Future<String?> addEmployee(
    String name,
    String phone,
    String email,
    String login,
    String password,
  ) async {
    var authData = await auth();
    Map<String, dynamic> data = {
      "Auth": authData,
      "Method": "UserCreate",
      "Body": {
        "Name": name,
        "Mobile": phone,
        "Email": email,
        "Username": login,
        "Password": password,
      },
      "Params": {},
    };

    final response = await dio.post(
      '$server/service/auth/agent/',
      options: header(),
      data: data,
    );

    if (response.data['Errors'] == null) {
      return null;
    } else {
      return response.data['Errors'][0]['Description'];
    }
  }

  Future<bool> editEmployee(
    String name,
    String phone,
    String email,
    String login,
    String password,
    String id,
  ) async {
    var authData = await auth();
    Map<String, dynamic> data = {
      "Auth": authData,
      "Method": "UserUpdate",
      "Body": {
        "ID": id,
        "Name": name,
        "Mobile": phone,
        "Email": email,
        "Username": login,
        "Password": password,
      },
      "Params": {},
    };

    final response = await dio.post(
      '$server/service/auth/agent/',
      options: header(),
      data: data,
    );

    if (response.data['Errors'] == null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateProfileUser(String password) async {
    var authData = await auth();
    Map<String, dynamic> data = {
      "Auth": authData,
      "Method": "Update",
      "Body": {
        "Password": password,
      },
      "Params": {},
    };

    final response = await dio.post(
      '$server/service/auth/user/',
      options: header(),
      data: data,
    );

    if (response.data['Errors'] == null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateProfileAgent(String password) async {
    var authData = await auth();
    Map<String, dynamic> data = {
      "Auth": authData,
      "Method": "UserUpdate",
      "Body": {
        "Password": password,
      },
      "Params": {},
    };

    final response = await dio.post(
      '$server/service/auth/agent/',
      options: header(),
      data: data,
    );

    if (response.data['Errors'] == null) {
      return true;
    } else {
      return false;
    }
  }
}
