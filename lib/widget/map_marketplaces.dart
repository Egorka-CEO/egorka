import 'package:egorka/core/bloc/market_place/market_place_bloc.dart';
import 'package:egorka/model/directions.dart';
import 'package:egorka/model/point_marketplace.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
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
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void initMarkers() async {
    final fromIcon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset('assets/images/from.png', 90));
    for (var element in widget.points) {
      // String name = element.name!.first.name![0];
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
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _customMarker(String title, Color color) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          'assets/icons/marker.svg',
          height: 30.h,
          color: color,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5.h),
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
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: YandexMap(
        mapObjects: mapObjects,
        onMapCreated: (controller) {
          mapController = controller;
          initMarkers();
        },
      ),
    );
  }
}
