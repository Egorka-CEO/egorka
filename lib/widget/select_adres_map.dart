import 'dart:async';
import 'dart:developer';
import 'package:egorka/helpers/location.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/point.dart' as pointModel;
import 'package:egorka/model/suggestions.dart';
import 'package:egorka/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class SelectAdresMap extends StatefulWidget {
  static const CameraPosition kPlex = CameraPosition(
    target: Point(
      latitude: 53.946798,
      longitude: 27.677952,
    ),
    zoom: 18,
  );
  @override
  State<SelectAdresMap> createState() => _SelectAdresMapState();
}

class _SelectAdresMapState extends State<SelectAdresMap> {
  YandexMapController? mapController;
  CameraPosition? pos;
  PanelController panelController = PanelController();
  String address = '';
  String? houseNumber;
  final addressController = StreamController<bool>();
  Suggestions? suggestions;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), (() {
      panelController.animatePanelToPosition(1);
    }));
  }

  void _getPosition() async {
    if (await LocationGeo().checkPermission()) {
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      if (mapController != null) {
        houseNumber = null;
        await mapController!.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: Point(
                latitude: position.latitude,
                longitude: position.longitude,
              ),
              zoom: 20,
              tilt: 0,
            ),
          ),
        );

        SearchResultWithSession adress = YandexSearch.searchByPoint(
          point: Point(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
          searchOptions: const SearchOptions(),
        );

        final value = await adress.result;

        final house = value.items!.first.toponymMetadata?.address
            .addressComponents[SearchComponentKind.house];

        if (house != null) {
          houseNumber = house;
        }

        address = value.items!.first.name;

        suggestions = Suggestions(
          iD: '',
          name: address,
          point: pointModel.Point(
            address: address,
            latitude: pos!.target.latitude,
            longitude: pos!.target.longitude,
          ),
          houseNumber: houseNumber,
        );

        addressController.add(true);
      }
    }
  }

  void _getAddress(int millisecondsDuaration) {
    Future.delayed(Duration(milliseconds: millisecondsDuaration), () async {
      if (await LocationGeo().checkPermission()) {
        SearchResultWithSession adress = YandexSearch.searchByPoint(
          point: Point(
            latitude: pos!.target.latitude,
            longitude: pos!.target.longitude,
          ),
          searchOptions: const SearchOptions(),
        );

        final value = await adress.result;

        final house = value.items!.first.toponymMetadata?.address
            .addressComponents[SearchComponentKind.house];

        if (house != null) {
          houseNumber = house;
        }

        address = value.items!.first.name;

        suggestions = Suggestions(
          iD: '',
          name: address,
          point: pointModel.Point(
            address: address,
            latitude: pos!.target.latitude,
            longitude: pos!.target.longitude,
          ),
          houseNumber: houseNumber,
        );

        addressController.add(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Material(
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.red,
                                ),
                              ),
                              const Align(
                                child: Text(
                                  'Выберите точку на карте',
                                  style: CustomTextStyle.black17w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.black.withOpacity(0.2),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 100.h),
                      child: YandexMap(
                        onMapCreated: (controller) {
                          mapController = controller;
                          _getPosition();
                          _getAddress(1000);
                        },
                        onCameraPositionChanged:
                            (cameraPosition, reason, finished) {
                          pos = cameraPosition;
                          if (pos != null && finished) {
                            _getAddress(0);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 100.h),
                child: CustomWidget.iconGPS(),
              ),
              SlidingUpPanel(
                controller: panelController,
                renderPanelSheet: false,
                isDraggable: false,
                collapsed: Container(),
                panel: Container(
                  height: 300,
                  margin: MediaQuery.of(context).viewInsets +
                      EdgeInsets.only(top: 15.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.r),
                      topRight: Radius.circular(25.r),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 1,
                        color: Colors.black12,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: StreamBuilder<bool>(
                    stream: addressController.stream,
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: 10.w,
                                left:
                                    ((MediaQuery.of(context).size.width * 45) /
                                            100)
                                        .w,
                                right:
                                    ((MediaQuery.of(context).size.width * 45) /
                                            100)
                                        .w,
                                bottom: 10.w),
                            child: Container(
                              height: 5.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.r),
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Flexible(
                            child: Text(
                              address,
                              style: CustomTextStyle.black15w700,
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(suggestions);
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.red),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                            ),
                            child: const Text('Подтвердить'),
                          ),
                          const Spacer(),
                        ],
                      );
                    },
                  ),
                ),
                onPanelClosed: () {},
                onPanelOpened: () {},
                onPanelSlide: (size) {},
                maxHeight: 180.h,
                minHeight: 120.h,
                defaultPanelState: PanelState.CLOSED,
              )
            ],
          ),
        ),
      ),
    );
  }
}
