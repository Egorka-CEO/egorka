import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatelessWidget {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(53.159646, 24.469827),
    zoom: 5,
  );

  const MapView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      zoomControlsEnabled: false,
      initialCameraPosition: _kGooglePlex,
      mapType: MapType.terrain,
      onMapCreated: (GoogleMapController controller) {
        print(controller);
      },
    );
  }
}
