import 'package:egorka/core/bloc/search/search_bloc.dart';
import 'package:egorka/helpers/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:egorka/model/point.dart' as pointModel;

class MapView extends StatefulWidget {
  final VoidCallback callBack;
  const MapView({Key? key, required this.callBack}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  CameraPosition? pos;
  Position? position;
  YandexMapController? mapController;
  final List<MapObject> mapObjects = [];
  final MapObjectId mapObjectId = const MapObjectId('polyline');

  @override
  void initState() {
    LocationGeo().checkPermission;
    super.initState();
  }

  void _getPosition() async {
    if (await LocationGeo().checkPermission()) {
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _jumpToPoint(
        pointModel.Point(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
    }
  }

  void _findMe() async {
    if (await LocationGeo().checkPermission()) {
      BlocProvider.of<SearchAddressBloc>(context).add(GetAddressPosition());
    }
  }

  void _jumpToPoint(pointModel.Point point) async {
    if (await LocationGeo().checkPermission()) {
      if (mapController != null) {
        await mapController!.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: Point(
                latitude: point.latitude,
                longitude: point.longitude,
              ),
              zoom: 15,
              tilt: 0,
            ),
          ),
        );
        widget.callBack();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: BlocBuilder<SearchAddressBloc, SearchAddressState>(
        buildWhen: (previous, current) {
          if (current is SearchAddressRoutePolilyne) {
            if (current.coasts.isNotEmpty) {
              mapObjects.clear();
              final mapObject = PolylineMapObject(
                mapId: mapObjectId,
                polyline: Polyline(
                    points: current.directionsBicycle!.routes!.first.geometry
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
                    northEast: Point(
                      latitude: current.directionsBicycle!.routes!.first
                          .geometry.first.latitude,
                      longitude: current.directionsBicycle!.routes!.first
                          .geometry.first.longitude,
                    ),
                    southWest: Point(
                      latitude: current.directionsBicycle!.routes!.first
                          .geometry.last.latitude,
                      longitude: current.directionsBicycle!.routes!.first
                          .geometry.last.longitude,
                    ),
                  ),
                ),
              );

              mapController!.getCameraPosition().then((value) {
                mapController!.moveCamera(CameraUpdate.zoomTo(value.zoom - 1));
              });
            }
            return true;
          } else if (current is EditPolilynesState) {
            if (current.directionsDrive != null) {
              mapObjects.clear();
              final mapObject = PolylineMapObject(
                mapId: mapObjectId,
                polyline: Polyline(
                    points: current.directionsDrive!.routes!.first.geometry
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
            } else {
              mapObjects.clear();
              final mapObject = PolylineMapObject(
                mapId: mapObjectId,
                polyline: Polyline(
                    points: current.directionsBicycle!.routes!.first.geometry
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
            }
            return false;
          } else if (current is FindMeState) {
            _findMe();
            return true;
          } else if (current is DeletePolilyneState) {
            mapObjects.clear();
            return true;
          } else if (current is JumpToPointState) {
            _jumpToPoint(current.point);
            return true;
          } else if (current is GetAddressSuccess) {
            _jumpToPoint(
              pointModel.Point(
                latitude: current.latitude,
                longitude: current.longitude,
              ),
            );
            return true;
          } else {
            return false;
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(bottom: 170.h),
            child: YandexMap(
              mapObjects: mapObjects,
              onMapCreated: (controller) {
                mapController = controller;
                _getPosition();
              },
              onCameraPositionChanged: (cameraPosition, reason, finished) {
                // pos = cameraPosition;
                // if (pos != null && finished) {
                //   BlocProvider.of<SearchAddressBloc>(context).add(
                //     ChangeMapPosition(
                //       pos!.target.latitude,
                //       pos!.target.longitude,
                //     ),
                //   );
                // }
              },
            ),
          );
        },
      ),
    );
  }
}
