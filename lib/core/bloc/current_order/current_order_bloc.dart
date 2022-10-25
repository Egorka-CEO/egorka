import 'dart:typed_data';

import 'package:egorka/core/network/directions_repository.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/model/address.dart';
import 'package:egorka/model/directions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
part 'current_order_event.dart';
part 'current_order_state.dart';

class CurrentOrderBloc extends Bloc<CurrentOrderEvent, CurrentOrderState> {
  late GeoData data;
  CurrentOrderBloc() : super(CurrentOrderStated()) {
    on<CurrentOrder>((event, emit) => _searchAddress(event, emit));
    // on<CurrentOrderClear>((event, emit) => _clearAddress());
    on<ChangeMapPosition>((event, emit) => _changeMapPosition(event, emit));
    on<SearchMeEvent>((event, emit) => emit(FindMeState()));
    on<DeletePolilyneEvent>((event, emit) => _deletePolyline(event, emit));
    on<JumpToPointEvent>((event, emit) => emit(JumpToPointState(event.point)));
    on<CurrentOrderPolilyne>((event, emit) => _getPoliline(event, emit));
  }

  void _deletePolyline(
      DeletePolilyneEvent event, Emitter<CurrentOrderState> emit) {
    emit(DeletePolilyneState());
  }

  void _searchAddress(
      CurrentOrder event, Emitter<CurrentOrderState> emit) async {
    emit(CurrentOrderLoading());
    if (event.value.length < 2) {
      emit(CurrentOrderStated());
    } else {
      var result = await Repository().getAddress(event.value);

      if (result != null) {
        emit(CurrentOrderSuccess(result));
      } else {
        emit(CurrentOrderFailed());
      }
    }
  }

  void _changeMapPosition(
      ChangeMapPosition event, Emitter<CurrentOrderState> emit) async {
    data = await Geocoder2.getDataFromCoordinates(
        latitude: event.coordinates.latitude.toDouble(),
        longitude: event.coordinates.longitude.toDouble(),
        language: 'RU',
        googleMapApiKey: "AIzaSyC2enrbrduQm8Ku7fBqdP8gOKanBct4JkQ");

    // emit(CurrentOrderSuccess(data));
  }
}

void _getPoliline(
    CurrentOrderPolilyne event, Emitter<CurrentOrderState> emit) async {
  final locationFrom = await Geocoder2.getDataFromAddress(
      address: event.from, googleMapApiKey: apiKey);
  final locationTo = await Geocoder2.getDataFromAddress(
      address: event.to, googleMapApiKey: apiKey);

  final directionsTo = await DirectionsRepository(dio: null).getDirections(
      origin: LatLng(locationFrom.latitude, locationFrom.longitude),
      destination: LatLng(locationTo.latitude, locationTo.longitude));

  if (directionsTo != null) {
    final fromIcon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset('assets/images/from.png', 90));
    final toIcon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset('assets/images/to.png', 90));
    emit(CurrentOrderRoutePolilyne(directionsTo, {
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
