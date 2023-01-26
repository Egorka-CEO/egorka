import 'package:egorka/core/bloc/market_place/market_place_bloc.dart';
import 'package:egorka/model/directions.dart';
import 'package:egorka/model/point_marketplace.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'dart:async';
import 'dart:ui' as ui;

class MapMarketPlaces extends StatefulWidget {
  List<PointMarketPlace> points;
  MapMarketPlaces({Key? key, required this.points}) : super(key: key);

  @override
  State<MapMarketPlaces> createState() => _MapMarketPlacesState();
}

class _MapMarketPlacesState extends State<MapMarketPlaces> {
  late CameraPosition pos;
  YandexMapController? mapController;
  Directions? routes;
  final List<MapObject> mapObjects = [];
  List<GlobalKey> globalKey = [];

  bool initMarks = false;

  Future<Uint8List> getBytesFromAsset(GlobalKey globalKey) async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    return pngBytes;
  }

  @override
  void initState() {
    super.initState();
  }

  Widget cstMrk(BuildContext context, String label, GlobalKey key) {
    return RepaintBoundary(
      key: key,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/marker.svg',
            height: 120.h,
            color: Colors.red,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5.h),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 40.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void initMarkers() async {
    int i = 0;
    for (var element in widget.points) {
      final fromIcon =
          BitmapDescriptor.fromBytes(await getBytesFromAsset(globalKey[i]));
      mapObjects.add(
        PlacemarkMapObject(
          mapId: MapObjectId('placemark_start${element.iD}'),
          point: Point(
            latitude: element.latitude!,
            longitude: element.longitude!,
          ),
          opacity: 1,
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(image: fromIcon),
          ),
          onTap: (mapObject, point) {
            BlocProvider.of<MarketPlacePageBloc>(context)
                .add(SelectMarketPlaces(element));
          },
        ),
      );
      ++i;
    }
    initMarks = true;
    setState(() {});
    mapController?.moveCamera(
        CameraUpdate.newCameraPosition(
          const CameraPosition(
            target: Point(
              latitude: 55.750104,
              longitude: 37.622895,
            ),
            zoom: 9,
          ),
        ),
        animation: const MapAnimation(
          type: MapAnimationType.linear,
          duration: 1,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Stack(
        children: [
          Stack(
            children: widget.points.map((e) {
              globalKey.add(GlobalKey());
              return cstMrk(context, e.name!.first.name![0], globalKey.last);
            }).toList(),
          ),
          Container(color: Colors.white),
          YandexMap(
            mapObjects: mapObjects,
            onMapCreated: (controller) async {
              mapController = controller;
              // Future.delayed(Duration(seconds: 1), () {
              initMarkers();
              // });
            },
          ),
        ],
      ),
    );
  }
}
