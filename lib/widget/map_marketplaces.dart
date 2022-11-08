import 'dart:ui';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:egorka/model/directions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarketPlaces extends StatefulWidget {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(56.159646, 35.469827),
    zoom: 4,
  );
  const MapMarketPlaces({Key? key}) : super(key: key);

  @override
  State<MapMarketPlaces> createState() => _MapMarketPlacesState();
}

class _MapMarketPlacesState extends State<MapMarketPlaces> {
  late CameraPosition pos;
  GoogleMapController? mapController;

  Directions? routes;
  List<MarkerData> marker = [];

  // final GlobalKey globalKey = GlobalKey();

  void initMarkers() async {
    // MyMarker(globalKey);
    marker.addAll([
      MarkerData(
        marker: const Marker(
            markerId: MarkerId('1'), position: LatLng(55.845808, 37.474588)),
        child: _customMarker('A', Colors.red),
      ),
      MarkerData(
        marker: const Marker(
            markerId: MarkerId('2'), position: LatLng(55.745650, 37.802628)),
        child: _customMarker('B', Colors.red),
      ),
      MarkerData(
        marker: const Marker(
            markerId: MarkerId('3'), position: LatLng(55.655145, 37.745033)),
        child: _customMarker('C', Colors.red),
      ),
      MarkerData(
        marker: const Marker(
            markerId: MarkerId('4'), position: LatLng(55.676376, 37.514654)),
        child: _customMarker('D', Colors.red),
      ),
      MarkerData(
        marker: const Marker(
            markerId: MarkerId('5'), position: LatLng(55.736837, 37.633578)),
        child: _customMarker('E', Colors.red),
      ),
      MarkerData(
        marker: const Marker(
            markerId: MarkerId('6'), position: LatLng(55.805024, 37.391651)),
        child: _customMarker('F', Colors.red),
      ),
    ]);
  }

  @override
  void initState() {
    super.initState();
    initMarkers();
  }

  Widget _customMarker(String title, Color color) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          'assets/icons/marker.svg',
          height: 30,
          color: color,
          // theme: SvgTheme(currentColor: Colors.red),
        ),
        // Icon(
        //   Icons.location_on,
        //   color: color,
        //   size: 30,
        // ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 11, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomGoogleMapMarkerBuilder(
        customMarkers: marker,
        builder: (context, markers) {
          if (markers == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return GoogleMap(
            markers: markers,
            padding: EdgeInsets.zero,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onCameraMove: (position) {
              pos = position;
            },
            initialCameraPosition: MapMarketPlaces._kGooglePlex,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
          );
        });
  }
}
