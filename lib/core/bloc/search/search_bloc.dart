import 'package:egorka/core/network/directions_repository.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/model/address.dart';
import 'package:egorka/model/coast_advanced.dart' as cstAdvanced;
import 'package:egorka/model/directions.dart';
import 'package:egorka/model/response_coast_base.dart' as respCoast;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
part 'search_event.dart';
part 'search_state.dart';

class SearchAddressBloc extends Bloc<SearchAddressEvent, SearchAddressState> {
  GeoData? data;
  bool isPolilyne = false;
  SearchAddressBloc() : super(SearchAddressStated()) {
    on<SearchAddress>(_searchAddress);
    on<SearchAddressClear>((event, emit) => _clearAddress());
    on<ChangeMapPosition>(_changeMapPosition);
    on<SearchMeEvent>((event, emit) => emit(FindMeState()));
    on<DeletePolilyneEvent>(_deletePolyline);
    on<JumpToPointEvent>((event, emit) => emit(JumpToPointState(event.point)));
    on<SearchAddressPolilyne>(_getPoliline);
  }

  void _deletePolyline(
      DeletePolilyneEvent event, Emitter<SearchAddressState> emit) {
    isPolilyne = false;
    emit(DeletePolilyneState());
  }

  void _searchAddress(
      SearchAddress event, Emitter<SearchAddressState> emit) async {
    emit(SearchAddressLoading());
    if (event.value.length < 2) {
      emit(SearchAddressStated());
    } else {
      var result = await Repository().getAddress(event.value);

      if (result != null) {
        emit(SearchAddressSuccess(result));
      } else {
        emit(SearchAddressFailed());
      }
    }
  }

  void _changeMapPosition(
      ChangeMapPosition event, Emitter<SearchAddressState> emit) async {
    if (!isPolilyne) {
      data = await Geocoder2.getDataFromCoordinates(
          latitude: event.coordinates.latitude.toDouble(),
          longitude: event.coordinates.longitude.toDouble(),
          language: 'RU',
          googleMapApiKey: "AIzaSyC2enrbrduQm8Ku7fBqdP8gOKanBct4JkQ");

      emit(ChangeAddressSuccess(data));
    }
  }

  void _getPoliline(
      SearchAddressPolilyne event, Emitter<SearchAddressState> emit) async {
    emit(SearchLoading());
    isPolilyne = true;

    final locationFrom = await Geocoder2.getDataFromAddress(
        address: event.suggestionsStart.first.name, googleMapApiKey: apiKey);
    final locationTo = await Geocoder2.getDataFromAddress(
        address: event.suggestionsEnd.last.name, googleMapApiKey: apiKey);

    final directions = await DirectionsRepository(dio: null).getDirections(
        origin: LatLng(locationFrom.latitude, locationFrom.longitude),
        destination: LatLng(locationTo.latitude, locationTo.longitude));
    if (directions != null) {
      final fromIcon = BitmapDescriptor.fromBytes(
          await getBytesFromAsset('assets/images/from.png', 90));
      final toIcon = BitmapDescriptor.fromBytes(
          await getBytesFromAsset('assets/images/to.png', 90));
 
      List<String> type = ['Walk', 'Car'];
      List<respCoast.CoastResponse> coasts = [];
      List<cstAdvanced.Locations> locations = [];

      for (var element in event.suggestionsStart) {
        locations.add(cstAdvanced.Locations(
          type: 'Pickup',
          point: cstAdvanced.Point(
            code: element.iD,
          ),
        ));
      }

      for (var element in event.suggestionsEnd) {
        locations.add(cstAdvanced.Locations(
          type: 'Drop',
          point: cstAdvanced.Point(
            code: element.iD,
          ),
        ));
      }

      for (var element in type) {
        final res = await Repository().getCoastAdvanced(
          cstAdvanced.CoastAdvanced(
            type: element,
            locations: locations,
          ),
        );
        if (res != null) {
          coasts.add(res);
        }
      }

      emit(
        SearchAddressRoutePolilyne(
          directions,
          {
            Marker(
              icon: fromIcon,
              markerId: const MarkerId('start'),
              position: LatLng(directions.polylinePoints.first.latitude,
                  directions.polylinePoints.first.longitude),
            ),
            Marker(
              icon: toIcon,
              markerId: const MarkerId('finish'),
              position: LatLng(directions.polylinePoints.last.latitude,
                  directions.polylinePoints.last.longitude),
            ),
          },
          coasts,
        ),
      );
    } else {
      isPolilyne = false;
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

  void _clearAddress() => emit(SearchAddressStated());
}
