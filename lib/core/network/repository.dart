import 'package:dio/dio.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/model/address.dart';

class Repository {
  static var uri = Uri.parse(server);
  var dio = Dio(BaseOptions(baseUrl: server));

  Future<List<Adress>?> getAddress(String input, String lang) async {
    const request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final response = await dio.get(
      request,
      queryParameters: {
        'input': input,
        'types': 'address',
        'language': lang,
        'components': 'country',
        'key': apiKey,
        'sessiontoken': ''
      },
    );

    if (response.statusCode == 200) {
      final result = response.data;
      if (result['status'] == 'OK') {
        return result['predictions']
            .map<Adress>((p) => Adress(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'INVALID_REQUEST') {
        return null;
      }
      return null;
    } else {
      return null;
    }
  }
}
