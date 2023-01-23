import 'dart:ui';

import 'package:yandex_mapkit/yandex_mapkit.dart';

const String server = 'https://ws.egorka.dev';
const String apiKey = 'AIzaSyC2enrbrduQm8Ku7fBqdP8gOKanBct4JkQ';

const Color backgroundColor = Color.fromRGBO(247, 247, 249, 1);
const Color helperTextColor = Color.fromRGBO(55, 55, 55, 1);

const CameraPosition kPlex = CameraPosition(
  target: Point(
    latitude: 53.946798,
    longitude: 27.677952,
  ),
  zoom: 18,
);
