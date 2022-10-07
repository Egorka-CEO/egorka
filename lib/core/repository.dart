import 'package:dio/dio.dart';
import 'package:egorka/helpers/constant.dart';

class Repository {
  static var uri = Uri.parse(server);
  var dio = Dio(BaseOptions(baseUrl: server));

  Future<void> getProfile() async {
    try {
      var response = await dio.get('');

      if (response.statusCode == 400) {}
      if (response.statusCode == 200) {}
    } catch (e) {}
  }
}
