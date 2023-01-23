import 'package:egorka/core/network/directions_repository.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/location.dart';
import 'package:egorka/model/address.dart';
import 'package:egorka/model/coast_advanced.dart';
import 'package:egorka/model/directions.dart';
import 'package:egorka/model/locations.dart';
import 'package:egorka/model/response_coast_base.dart';
import 'package:egorka/model/suggestions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'dart:ui' as ui;
import 'package:egorka/model/point.dart' as pointModel;
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googleMap;

part 'search_event.dart';
part 'search_state.dart';

class SearchAddressBloc extends Bloc<SearchAddressEvent, SearchAddressState> {
  bool isPolilyne = false;
  SearchAddressBloc() : super(SearchAddressStated()) {
    on<SearchAddress>(_searchAddress);
    on<SearchAddressClear>((event, emit) => _clearAddress());
    on<ChangeMapPosition>(_changeMapPosition);
    on<SearchMeEvent>((event, emit) => emit(FindMeState()));
    on<DeletePolilyneEvent>(_deletePolyline);
    on<JumpToPointEvent>((event, emit) => emit(JumpToPointState(event.point)));
    on<SearchAddressPolilyne>(_getPoliline);
    on<GetAddressPosition>(_getAddress);
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
      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        event.lat,
        event.lon,
        localeIdentifier: 'ru',
      );

      String address = '';

      if (placemarks.first.street!.isNotEmpty) {
        address += placemarks.first.street!;
        if (placemarks.first.locality!.isNotEmpty) {
          address += ', г.${placemarks.first.locality!}';
        }
      } else {
        address = placemarks.first.locality!;
      }

      String? errorAddress;

      if (placemarks.first.subThoroughfare!.isEmpty) {
        errorAddress = 'Ошибка: Укажите номер дома';
      }

      emit(
        ChangeAddressSuccess(
          address,
          event.lat,
          event.lon,
          errorAddress,
        ),
      );
    }
  }

  void _getAddress(
      GetAddressPosition event, Emitter<SearchAddressState> emit) async {
    if (await LocationGeo().checkPermission()) {
      var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        localeIdentifier: 'ru',
      );

      String address = '';

      if (placemarks.first.street!.isNotEmpty) {
        address += placemarks.first.street!;
        if (placemarks.first.locality!.isNotEmpty) {
          address += ', г.${placemarks.first.locality!}';
        }
      } else {
        address = placemarks.first.locality!;
      }

      String? errorAddress;

      if (placemarks.first.subThoroughfare!.isEmpty) {
        errorAddress = 'Ошибка: Укажите номер дома';
      }

      emit(
        GetAddressSuccess(
          address,
          position.latitude,
          position.longitude,
          errorAddress,
        ),
      );
    }
  }

  void _getPoliline(
      SearchAddressPolilyne event, Emitter<SearchAddressState> emit) async {
    emit(SearchLoading());
    isPolilyne = true;

    // final locationFrom = await Geocoder2.getDataFromAddress(
    //   address: event.suggestionsStart.first!.name,
    //   googleMapApiKey: apiKey,
    // );
    // final locationTo = await Geocoder2.getDataFromAddress(
    //   address: event.suggestionsEnd.last!.name,
    //   googleMapApiKey: apiKey,
    // );

    final fromIcon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset('assets/images/from.png', 90));
    final toIcon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset('assets/images/to.png', 90));

    Directions? directions;
    try {
      directions = await DirectionsRepository(dio: null).getDirections(
        origin: googleMap.LatLng(
          event.suggestionsStart.last!.point!.latitude,
          event.suggestionsStart.last!.point!.longitude,
        ),
        destination: googleMap.LatLng(
          event.suggestionsEnd.last!.point!.latitude,
          event.suggestionsEnd.last!.point!.longitude,
        ),
      );
    } catch (e) {
      // emit(
      //   SearchAddressRoutePolilyne(
      //     Directions(
      //         bounds: LatLngBounds(
      //           southwest: const LatLng(2, 2),
      //           northeast: const LatLng(3, 3),
      //         ),
      //         polylinePoints: [],
      //         totalDistance: '',
      //         totalDuration: ''),
      //     {
      //       Marker(
      //         icon: fromIcon,
      //         markerId: const MarkerId('start'),
      //       ),
      //       Marker(
      //         icon: toIcon,
      //         markerId: const MarkerId('finish'),
      //       ),
      //     },
      //     [],
      //   ),
      // );
    }
    if (directions != null) {
      List<String> type = ['Walk', 'Car'];
      List<CoastResponse> coasts = [];
      List<Location> locations = [];

      for (var element in event.suggestionsStart) {
        locations.add(
          Location(
            type: 'Pickup',
            point: pointModel.Point(
              latitude: element!.point!.latitude!,
              longitude: element.point!.longitude!,
            ),
          ),
        );
      }

      for (var element in event.suggestionsEnd) {
        locations.add(
          Location(
            type: 'Drop',
            point: pointModel.Point(
              latitude: element!.point!.latitude,
              longitude: element.point!.longitude,
            ),
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
            [
              PlacemarkMapObject(
                mapId: const MapObjectId('placemark_start'),
                point: Point(
                  latitude: directions.polylinePoints.first.latitude,
                  longitude: directions.polylinePoints.first.longitude,
                ),
                opacity: 1,
                icon: PlacemarkIcon.single(
                  PlacemarkIconStyle(image: fromIcon),
                ),
              ),
              PlacemarkMapObject(
                mapId: const MapObjectId('placemark_end'),
                point: Point(
                  latitude: directions.polylinePoints.last.latitude,
                  longitude: directions.polylinePoints.last.longitude,
                ),
                opacity: 1,
                icon: PlacemarkIcon.single(
                  PlacemarkIconStyle(image: toIcon),
                ),
              ),
            ],
            coasts,
          ),
        );
      } catch (e) {
        isPolilyne = false;
        print('object error $e');
        // emit(SearchAddressRoutePolilyne(
        //   directions,
        //   {
        //     Marker(
        //       icon: fromIcon,
        //       markerId: const MarkerId('start'),
        //       position: LatLng(directions.polylinePoints.first.latitude,
        //           directions.polylinePoints.first.longitude),
        //     ),
        //     Marker(
        //       icon: toIcon,
        //       markerId: const MarkerId('finish'),
        //       position: LatLng(directions.polylinePoints.last.latitude,
        //           directions.polylinePoints.last.longitude),
        //     ),
        //   },
        //   [],
        // ));
      }
      // } else {
      // isPolilyne = false;
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
