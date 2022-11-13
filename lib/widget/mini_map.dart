import 'package:egorka/core/bloc/current_order/current_order_bloc.dart';
import 'package:egorka/model/directions.dart';
import 'package:egorka/model/route_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MiniMapView extends StatefulWidget {
  List<RouteOrder> routeOrder;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(56.159646, 35.469827),
    zoom: 4,
  );
  MiniMapView({Key? key, required this.routeOrder}) : super(key: key);

  @override
  State<MiniMapView> createState() => _MiniMapViewState();
}

class _MiniMapViewState extends State<MiniMapView> {
  late CameraPosition pos;
  Marker? firstMarker;
  Marker? secondMarker;
  Position? position;
  GoogleMapController? mapController;

  Directions? routes;
  Set<Marker> marker = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CurrentOrderBloc>(context).add(CurrentOrderPolilyne(
        widget.routeOrder[0].adress, widget.routeOrder[1].adress));
    return BlocBuilder<CurrentOrderBloc, CurrentOrderState>(
        buildWhen: (previous, current) {
      if (current is CurrentOrderRoutePolilyne) {
        routes = current.routes;
        marker = current.markers;
        mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(routes!.bounds, 20.w),
        );
        return true;
      }
      return true;
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
        initialCameraPosition: MiniMapView._kGooglePlex,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      );
    });
  }
}
