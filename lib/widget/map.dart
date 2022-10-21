import 'package:egorka/core/bloc/search/search_bloc.dart';
import 'package:egorka/helpers/location.dart';
import 'package:egorka/model/address.dart';
import 'package:egorka/model/directions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(53.159646, 24.469827),
    zoom: 5,
  );
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late CameraPosition pos;
  Marker? firstMarker;
  Marker? secondMarker;
  Position? position;
  GoogleMapController? mapController;

  Directions? routes;
  Set<Marker> marker = {};

  @override
  void initState() {
    Location().checkPermission;

    super.initState();
  }

  void _getPosition() async {
    if (await Location().checkPermission()) {
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (mapController != null) {
        mapController!.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 15,
              tilt: 0,
            ),
          ),
        );
      }
    }
  }

  void _findMe() async {
    if (await Location().checkPermission()) {
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 15,
              tilt: 0,
            ),
          ),
        );
      }
    }
  }

  void _jumpToPoint(Point point) async {
    if (await Location().checkPermission()) {
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(point.latitude, point.longitude),
              zoom: 15,
              tilt: 0,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchAddressBloc, SearchAddressState>(
        buildWhen: (previous, current) {
      if (current is SearchAddressRoutePolilyne) {
        routes = current.routes;
        marker = current.markers;
        return true;
      } else if (current is FindMeState) {
        _findMe();
        return true;
      } else if (current is DeletePolilyneState) {
        print('delete');
        marker = {};
        routes = null;
        return true;
      } else if (current is JumpToPointState) {
        _jumpToPoint(current.point);
        return true;
      } else {
        return false;
      }
    }, builder: (context, snapshot) {
      return GoogleMap(
        markers: marker,
        polylines: {
          if (routes != null)
            Polyline(
              polylineId: const PolylineId('route'),
              visible: true,
              width: 5,
              points: routes != null
                  ? routes!.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList()
                  : [],
              color: Colors.red,
            )
        },
        padding: EdgeInsets.zero,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        onCameraMove: (position) {
          pos = position;
        },
        onCameraIdle: () {
          BlocProvider.of<SearchAddressBloc>(context)
              .add(ChangeMapPosition(pos.target));
        },
        initialCameraPosition: MapView._kGooglePlex,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
          _getPosition();
        },
      );
    });
  }
}
