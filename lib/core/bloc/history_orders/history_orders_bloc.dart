import 'package:egorka/core/network/repository.dart';
import 'package:egorka/model/create_form_model.dart';
import 'package:egorka/model/locations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;
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
    List<DrivingSessionResult> drivingSessionResult = [];

    for (int i = 0; i < event.locations.length - 1; i++) {
      DrivingResultWithSession? requestRoutes = YandexDriving.requestRoutes(
        points: [
          RequestPoint(
              point: Point(
                latitude: event.locations[i].point!.latitude,
                longitude: event.locations[i].point!.longitude,
              ),
              requestPointType: RequestPointType.wayPoint),
          RequestPoint(
              point: Point(
                latitude: event.locations[i + 1].point!.latitude,
                longitude: event.locations[i + 1].point!.longitude,
              ),
              requestPointType: RequestPointType.wayPoint),
        ],
        drivingOptions: const DrivingOptions(),
      );

      drivingSessionResult.add(await requestRoutes.result);
    }

    List<BicycleSessionResult> bicycleSessionResult = [];

    for (int i = 0; i < event.locations.length - 1; i++) {
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

      bicycleSessionResult.add(await requestRoutesBicycle.result);
    }

    final fromIcon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset('assets/images/from.png', 90));
    final toIcon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset('assets/images/to.png', 90));
    emit(
      HistoryOrderRoutePolilyne(
        drivingSessionResult,
        bicycleSessionResult,
        PlacemarkIcon.single(PlacemarkIconStyle(image: fromIcon)),
        PlacemarkIcon.single(PlacemarkIconStyle(image: toIcon)),
      ),
    );
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
