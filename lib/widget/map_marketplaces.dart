import 'dart:developer';

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
  List<BitmapDescriptor> listIcon = [];

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

  List<String> filterMarketplace = [];
  String selectFilter = '';

  Widget cstMrk(BuildContext context, String label, GlobalKey key) {
    if (!filterMarketplace.contains(label)) filterMarketplace.add(label);

    return RepaintBoundary(
      key: key,
      child: SizedBox(
        height: 120.h,
        width: 100.h,
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
      ),
    );
  }

  void updateFilter() {
    for (int i = 0; i < widget.points.length; i++) {
      if (selectFilter == widget.points[i].name!.first.name![0] ||
          selectFilter == '') {
        mapObjects.add(
          PlacemarkMapObject(
            mapId: MapObjectId('placemark_start${widget.points[i].iD}'),
            point: Point(
              latitude: widget.points[i].latitude!,
              longitude: widget.points[i].longitude!,
            ),
            consumeTapEvents: true,
            opacity: 1,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(image: listIcon[i]),
            ),
            onTap: (mapObject, point) {
              BlocProvider.of<MarketPlacePageBloc>(context)
                  .add(SelectMarketPlaces(widget.points[i]));
            },
          ),
        );
      }
    }

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
      ),
    );
  }

  void initMarkers() async {
    int i = 0;
    for (var element in widget.points) {
      final fromIcon =
          BitmapDescriptor.fromBytes(await getBytesFromAsset(globalKey[i]));
      listIcon.add(fromIcon);
      mapObjects.add(
        PlacemarkMapObject(
          mapId: MapObjectId('placemark_start${element.iD}'),
          point: Point(
            latitude: element.latitude!,
            longitude: element.longitude!,
          ),
          consumeTapEvents: true,
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
    BlocProvider.of<MarketPlacePageBloc>(context)
        .emit(FindMarketPlacesSuccess());
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
      ),
    );
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
              initMarkers();
            },
          ),
          Padding(
            padding: EdgeInsets.all(20.h),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 40.w,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.r),
                  ),
                  color: Colors.white,
                ),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filterMarketplace.length,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (selectFilter == filterMarketplace[index]) {
                          selectFilter = '';
                        } else {
                          selectFilter = filterMarketplace[index];
                        }
                        mapObjects.clear();
                        setState(() {});
                        updateFilter();
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.h),
                        color: selectFilter == filterMarketplace[index]
                            ? Colors.red
                            : Colors.white,
                        child: Center(
                          child: Text(
                            filterMarketplace[index],
                            style: TextStyle(
                              color: selectFilter == filterMarketplace[index]
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
