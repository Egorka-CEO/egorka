import 'package:egorka/core/network/directions_repository.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/helpers/location.dart';
import 'package:egorka/model/address.dart';
import 'package:egorka/model/coast_advanced.dart';
import 'package:egorka/model/directions.dart';
import 'package:egorka/model/locations.dart';
import 'package:egorka/model/point.dart';
import 'package:egorka/model/response_coast_base.dart';
import 'package:egorka/model/suggestions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
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
    on<DeleteGeoDateEvent>(_deleteGeoDate);
    on<GetAddressPosition>(_getAddress);
  }

  void _deleteGeoDate(
      DeleteGeoDateEvent event, Emitter<SearchAddressState> emit) {
    data = null;
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
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      data = await Geocoder2.getDataFromCoordinates(
          latitude: event.coordinates.latitude,
          longitude: event.coordinates.longitude,
          language: 'RU',
          googleMapApiKey: "AIzaSyC2enrbrduQm8Ku7fBqdP8gOKanBct4JkQ");

      emit(ChangeAddressSuccess(data));
    }
  }

  void _getAddress(
      GetAddressPosition event, Emitter<SearchAddressState> emit) async {
    if (await LocationGeo().checkPermission()) {
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      data = await Geocoder2.getDataFromCoordinates(
          latitude: position.latitude,
          longitude: position.longitude,
          language: 'RU',
          googleMapApiKey: "AIzaSyC2enrbrduQm8Ku7fBqdP8gOKanBct4JkQ");

      emit(GetAddressSuccess(data));
    }
  }

  void _getPoliline(
      SearchAddressPolilyne event, Emitter<SearchAddressState> emit) async {
    emit(SearchLoading());
    isPolilyne = true;

    final locationFrom = data ??
        await Geocoder2.getDataFromAddress(
            address: event.suggestionsStart.first!.name,
            googleMapApiKey: apiKey);
    final locationTo = await Geocoder2.getDataFromAddress(
        address: event.suggestionsEnd.last!.name, googleMapApiKey: apiKey);

    final fromIcon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset('assets/images/from.png', 90));
    final toIcon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset('assets/images/to.png', 90));

    Directions? directions;
    try {
      directions = await DirectionsRepository(dio: null).getDirections(
          origin: LatLng(locationFrom.latitude, locationFrom.longitude),
          destination: LatLng(locationTo.latitude, locationTo.longitude));
    } catch (e) {
      emit(
        SearchAddressRoutePolilyne(
          Directions(
              bounds: LatLngBounds(
                southwest: LatLng(2, 2),
                northeast: LatLng(3, 3),
              ),
              polylinePoints: [],
              totalDistance: '',
              totalDuration: ''),
          {
            Marker(
              icon: fromIcon,
              markerId: const MarkerId('start'),
            ),
            Marker(
              icon: toIcon,
              markerId: const MarkerId('finish'),
            ),
          },
          [],
        ),
      );
    }
    if (directions != null) {
      List<String> type = ['Walk', 'Car'];
      List<CoastResponse> coasts = [];
      List<Location> locations = [];

      // if (data == null) {
        for (var element in event.suggestionsStart) {
          locations.add(
            Location(
              type: 'Pickup',
              point: Point(
                latitude: element!.point!.latitude!,
                longitude: element.point!.longitude!,
              ),
            ),
          );
        }
      // } else {
      //   locations.add(
      //     Location(
      //       type: 'Pickup',
      //       point: Point(
      //         latitude: data!.latitude,
      //         longitude: data!.longitude,
      //       ),
      //     ),
      //   );
      // }

      for (var element in event.suggestionsEnd) {
        locations.add(
          Location(
            type: 'Drop',
            point: Point(
                latitude: element!.point!.latitude!,
                longitude: element.point!.longitude!),
          ),
        );
      }

      try {
        for (var element in type) {
          final res = await Repository().getCoastAdvanced(
            CoastAdvanced(
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
      } catch (e) {
        isPolilyne = false;
        emit(SearchAddressRoutePolilyne(
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
          [],
        ));
      }
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
