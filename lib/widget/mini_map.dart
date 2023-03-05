import 'dart:developer';

import 'package:egorka/core/bloc/history_orders/history_orders_bloc.dart';
import 'package:egorka/model/locations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MiniMapView extends StatefulWidget {
  List<Location> locations;
  String type;
  int pointSentCount;

  MiniMapView({
    Key? key,
    required this.locations,
    required this.type,
    required this.pointSentCount,
  }) : super(key: key);

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
          if (widget.type == 'Walk') {
            List<Point> points = [];
            for (var a in current.bicycleSessionResult) {
              for (var b in a.routes!.first.geometry) {
                points.add(Point(latitude: b.latitude, longitude: b.longitude));
              }
            }
            mapObjects.clear();
            final mapObject = PolylineMapObject(
              mapId: mapObjectId,
              polyline: Polyline(points: points),
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

            mapObjects.add(
              PlacemarkMapObject(
                mapId: const MapObjectId('mapIdStart'),
                point: Point(
                  latitude: current.bicycleSessionResult.first.routes!.first
                      .geometry.first.latitude,
                  longitude: current.bicycleSessionResult.first.routes!.first
                      .geometry.first.longitude,
                ),
                opacity: 1,
                icon: current.startMarker,
              ),
            );

            for (int i = 0; i < current.bicycleSessionResult.length; i++) {
              if (i < widget.pointSentCount - 1) {
                mapObjects.add(
                  PlacemarkMapObject(
                    mapId: MapObjectId('mapId$i'),
                    point: Point(
                      latitude: current.bicycleSessionResult[i].routes!.first
                          .geometry.last.latitude,
                      longitude: current.bicycleSessionResult[i].routes!.first
                          .geometry.last.longitude,
                    ),
                    opacity: 1,
                    icon: current.startMarker,
                  ),
                );
              } else {
                mapObjects.add(
                  PlacemarkMapObject(
                    mapId: MapObjectId('mapId$i'),
                    point: Point(
                      latitude: current.bicycleSessionResult[i].routes!.first
                          .geometry.last.latitude,
                      longitude: current.bicycleSessionResult[i].routes!.first
                          .geometry.last.longitude,
                    ),
                    opacity: 1,
                    icon: current.endMarker,
                  ),
                );
              }
            }

            mapController!.moveCamera(
              CameraUpdate.newBounds(
                BoundingBox(
                  northEast: points.first,
                  southWest: points.last,
                ),
              ),
            );

            mapController!.getCameraPosition().then((value) {
              mapController!.moveCamera(
                CameraUpdate.zoomTo(value.zoom - widget.pointSentCount),
              );
            });
          } else {
            List<Point> points = [];
            for (var a in current.routes) {
              for (var b in a.routes!.first.geometry) {
                points.add(Point(latitude: b.latitude, longitude: b.longitude));
              }
            }
            mapObjects.clear();
            final mapObject = PolylineMapObject(
              mapId: mapObjectId,
              polyline: Polyline(points: points),
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

            // BoundingBoxHelper.getBounds(Polyline geometry).

            mapObjects.add(
              PlacemarkMapObject(
                mapId: const MapObjectId('mapIdStart'),
                point: Point(
                  latitude: current
                      .routes.first.routes!.first.geometry.first.latitude,
                  longitude: current
                      .routes.first.routes!.first.geometry.first.longitude,
                ),
                opacity: 1,
                icon: current.startMarker,
              ),
            );

            for (int i = 0; i < current.routes.length; i++) {
              if (i < widget.pointSentCount - 1) {
                mapObjects.add(
                  PlacemarkMapObject(
                    mapId: MapObjectId('mapId$i'),
                    point: Point(
                      latitude: current
                          .routes[i].routes!.first.geometry.last.latitude,
                      longitude: current
                          .routes[i].routes!.first.geometry.last.longitude,
                    ),
                    opacity: 1,
                    icon: current.startMarker,
                  ),
                );
              } else {
                mapObjects.add(
                  PlacemarkMapObject(
                    mapId: MapObjectId('mapId$i'),
                    point: Point(
                      latitude: current
                          .routes[i].routes!.first.geometry.last.latitude,
                      longitude: current
                          .routes[i].routes!.first.geometry.last.longitude,
                    ),
                    opacity: 1,
                    icon: current.endMarker,
                  ),
                );
              }
            }

            mapController!.moveCamera(
              CameraUpdate.newBounds(
                BoundingBox(
                  northEast: points.first,
                  southWest: points.last,
                ),
              ),
            );

            mapController!.getCameraPosition().then((value) {
              mapController!.moveCamera(
                CameraUpdate.zoomTo(value.zoom - widget.pointSentCount),
              );
            });
          }
        }
        return true;
      }, builder: (context, snapshot) {
        return YandexMap(
          tiltGesturesEnabled: false,
          rotateGesturesEnabled: false,
          scrollGesturesEnabled: false,
          zoomGesturesEnabled: false,
          mapObjects: mapObjects,
          onMapCreated: (controller) {
            mapController = controller;
          },
        );
      }),
    );
  }
}
