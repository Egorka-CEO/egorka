import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:egorka/model/directions.dart';
import 'package:egorka/model/marketplaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarketPlaces extends StatefulWidget {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(56.159646, 35.469827),
    zoom: 4,
  );
  List<Points> points;
  MapMarketPlaces({Key? key, required this.points}) : super(key: key);

  @override
  State<MapMarketPlaces> createState() => _MapMarketPlacesState();
}

class _MapMarketPlacesState extends State<MapMarketPlaces> {
  late CameraPosition pos;
  GoogleMapController? mapController;

  Directions? routes;
  List<MarkerData> marker = [];

  void initMarkers() async {
    for (var element in widget.points) {
      marker.add(MarkerData(
        marker: Marker(
            markerId: MarkerId(element.ID), position: LatLng(element.latitude, element.longitude)),
        child: _customMarker(element.name[0].name, Colors.red),
      ));
    }
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
        ),
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
