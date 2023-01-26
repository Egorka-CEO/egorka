import 'package:egorka/core/bloc/history_orders/history_orders_bloc.dart';
import 'package:egorka/model/locations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MiniMapView extends StatefulWidget {
  List<Location> locations;
  MiniMapView({Key? key, required this.locations}) : super(key: key);

  @override
  State<MiniMapView> createState() => _MiniMapViewState();
}

class _MiniMapViewState extends State<MiniMapView> {
  late CameraPosition pos;
  Position? position;
  YandexMapController? mapController;
  final List<MapObject> mapObjects = [];
  final MapObjectId mapObjectId = const MapObjectId('polyline');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<HistoryOrdersBloc>(context)
        .add(HistoryOrderPolilyne(widget.locations));
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: BlocBuilder<HistoryOrdersBloc, HistoryOrdersState>(
          buildWhen: (previous, current) {
        if (current is HistoryOrderRoutePolilyne) {
          mapObjects.clear();
          final mapObject = PolylineMapObject(
            mapId: mapObjectId,
            polyline: Polyline(
                points: current.routes.routes!.first.geometry
                    .map((e) =>
                        Point(latitude: e.latitude, longitude: e.longitude))
                    .toList()),
            strokeColor: Colors.red,
            strokeWidth: 5,
            outlineColor: Colors.white,
            outlineWidth: 1,
            turnRadius: 10.0,
            arcApproximationStep: 1.0,
            gradientLength: 1.0,
            isInnerOutlineEnabled: true,
          );
          mapObjects.add(mapObject);

          final placemarks = current.markers;
          mapObjects.addAll(placemarks);

          mapController!.moveCamera(
            CameraUpdate.newBounds(
              BoundingBox(
                northEast: current.routes.routes!.first.geometry.first,
                southWest: current.routes.routes!.first.geometry.last,
              ),
            ),
          );

          mapController!.getCameraPosition().then((value) {
            mapController!.moveCamera(CameraUpdate.zoomTo(value.zoom - 0.5));
          });
        }
        return true;
      }, builder: (context, snapshot) {
        return YandexMap(
          mapObjects: mapObjects,
          onMapCreated: (controller) {
            mapController = controller;
          },
        );
      }),
    );
  }
}
