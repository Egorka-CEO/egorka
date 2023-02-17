import 'package:egorka/core/network/directions_repository.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/model/create_form_model.dart';
import 'package:egorka/model/directions.dart';
import 'package:egorka/model/locations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart' as googleMap;
import 'package:yandex_mapkit/yandex_mapkit.dart';

part 'history_orders_event.dart';
part 'history_orders_state.dart';

class HistoryOrdersBloc extends Bloc<HistoryOrdersEvent, HistoryOrdersState> {
  List<CreateFormModel> coast = [];
  HistoryOrdersBloc() : super(HistoryOrdesrStated()) {
    on<OpenBtmSheetHistoryEvent>(_openBtmSheet);
    on<CloseBtmSheetHistoryEvent>(_closeBtmSheet);
    on<HistoryUpdateListEvent>(_updateList);
    on<HistoryOrderPolilyne>(_getPoliline);
    on<GetListOrdersEvent>(_getListOrders);
  }

  void _openBtmSheet(
          OpenBtmSheetHistoryEvent event, Emitter<HistoryOrdersState> emit) =>
      emit(HistoryOpenBtmSheetState());

  void _closeBtmSheet(
          CloseBtmSheetHistoryEvent event, Emitter<HistoryOrdersState> emit) =>
      emit(HistoryCloseBtmSheetState());

  void _updateList(
      HistoryUpdateListEvent event, Emitter<HistoryOrdersState> emit) {
    List<CreateFormModel> coastTemp = [];
    coastTemp.add(event.coast);
    coastTemp.addAll(coast);
    coast.clear();
    coast.addAll(coastTemp);
    emit(HistoryUpdateList(coast));
  }

  void _getListOrders(
      GetListOrdersEvent event, Emitter<HistoryOrdersState> emit) async {
    List<CreateFormModel>? list = await Repository().getListForm();
    if (list != null) {
      coast.clear();
      coast.addAll(list);
      emit(HistoryUpdateList(list));
    }
  }

  void _getPoliline(
      HistoryOrderPolilyne event, Emitter<HistoryOrdersState> emit) async {
    DrivingSessionResult? drivingSessionResult;

    DrivingResultWithSession? requestRoutes = YandexDriving.requestRoutes(
      points: [
        RequestPoint(
            point: Point(
              latitude: event.locations.first.point!.latitude,
              longitude: event.locations.first.point!.longitude,
            ),
            requestPointType: RequestPointType.wayPoint),
        RequestPoint(
            point: Point(
              latitude: event.locations.last.point!.latitude,
              longitude: event.locations.last.point!.longitude,
            ),
            requestPointType: RequestPointType.wayPoint),
      ],
      drivingOptions: const DrivingOptions(),
    );

    drivingSessionResult = await requestRoutes.result;

    BicycleSessionResult? bicycleSessionResult;

    BicycleResultWithSession? requestRoutesBicycle =
        YandexBicycle.requestRoutes(
      points: [
        RequestPoint(
            point: Point(
              latitude: event.locations.first.point!.latitude,
              longitude: event.locations.first.point!.longitude,
            ),
            requestPointType: RequestPointType.wayPoint),
        RequestPoint(
            point: Point(
              latitude: event.locations.last.point!.latitude,
              longitude: event.locations.last.point!.longitude,
            ),
            requestPointType: RequestPointType.wayPoint),
      ],
      bicycleVehicleType: BicycleVehicleType.bicycle,
    );

    bicycleSessionResult = await requestRoutesBicycle.result;

    if (drivingSessionResult != null && bicycleSessionResult != null) {
      final fromIcon = BitmapDescriptor.fromBytes(
          await getBytesFromAsset('assets/images/from.png', 90));
      final toIcon = BitmapDescriptor.fromBytes(
          await getBytesFromAsset('assets/images/to.png', 90));
      emit(
        HistoryOrderRoutePolilyne(
          drivingSessionResult,
          bicycleSessionResult,
          [
            PlacemarkMapObject(
              mapId: const MapObjectId('placemark_start'),
              point: Point(
                latitude:
                    drivingSessionResult.routes!.first.geometry.first.latitude,
                longitude:
                    drivingSessionResult.routes!.first.geometry.first.longitude,
              ),
              opacity: 1,
              icon: PlacemarkIcon.single(
                PlacemarkIconStyle(image: fromIcon),
              ),
            ),
            PlacemarkMapObject(
              mapId: const MapObjectId('placemark_end'),
              point: Point(
                latitude:
                    drivingSessionResult.routes!.first.geometry.last.latitude,
                longitude:
                    drivingSessionResult.routes!.first.geometry.last.longitude,
              ),
              opacity: 1,
              icon: PlacemarkIcon.single(
                PlacemarkIconStyle(image: toIcon),
              ),
            ),
          ],
        ),
      );
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
