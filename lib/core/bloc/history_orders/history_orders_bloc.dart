import 'package:egorka/core/network/directions_repository.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/model/create_form_model.dart';
import 'package:egorka/model/directions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'history_orders_event.dart';
part 'history_orders_state.dart';

class HistoryOrdersBloc extends Bloc<HistoryOrdersEvent, HistoryOrdersState> {
  List<CreateFormModel> coast = [];
  HistoryOrdersBloc() : super(HistoryOrdesrStated()) {
    on<OpenBtmSheetHistoryEvent>((event, emit) => _openBtmSheet(event, emit));
    on<CloseBtmSheetHistoryEvent>((event, emit) => _closeBtmSheet(event, emit));
    on<HistoryUpdateListEvent>((event, emit) => _updateList(event, emit));
    on<HistoryOrderPolilyne>((event, emit) => _getPoliline(event, emit));
  }

  void _openBtmSheet(
          OpenBtmSheetHistoryEvent event, Emitter<HistoryOrdersState> emit) =>
      emit(HistoryOpenBtmSheetState());

  void _closeBtmSheet(
          CloseBtmSheetHistoryEvent event, Emitter<HistoryOrdersState> emit) =>
      emit(HistoryCloseBtmSheetState());

  void _updateList(
      HistoryUpdateListEvent event, Emitter<HistoryOrdersState> emit) {
    coast.add(event.coast);
    emit(HistoryUpdateList());
  }

  void _getPoliline(
      HistoryOrderPolilyne event, Emitter<HistoryOrdersState> emit) async {
    final locationFrom = await Geocoder2.getDataFromCoordinates(
        latitude: event.locations.first.point.Latitude,
        longitude: event.locations.first.point.Longitude,
        googleMapApiKey: apiKey);
    final locationTo = await Geocoder2.getDataFromCoordinates(
        latitude: event.locations.last.point.Latitude,
        longitude: event.locations.last.point.Longitude,
        googleMapApiKey: apiKey);

    final directionsTo = await DirectionsRepository(dio: null).getDirections(
        origin: LatLng(locationFrom.latitude, locationFrom.longitude),
        destination: LatLng(locationTo.latitude, locationTo.longitude));

    if (directionsTo != null) {
      final fromIcon = BitmapDescriptor.fromBytes(
          await getBytesFromAsset('assets/images/from.png', 90));
      final toIcon = BitmapDescriptor.fromBytes(
          await getBytesFromAsset('assets/images/to.png', 90));
      emit(HistoryOrderRoutePolilyne(directionsTo, {
        Marker(
          icon: fromIcon,
          markerId: const MarkerId('start'),
          position: LatLng(directionsTo.polylinePoints.first.latitude,
              directionsTo.polylinePoints.first.longitude),
        ),
        Marker(
          icon: toIcon,
          markerId: const MarkerId('finish'),
          position: LatLng(directionsTo.polylinePoints.last.latitude,
              directionsTo.polylinePoints.last.longitude),
        ),
      }));
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
