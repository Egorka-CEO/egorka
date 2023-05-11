import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/location.dart';
import 'package:egorka/model/address.dart';
import 'package:egorka/model/coast_advanced.dart';
import 'package:egorka/model/coast_marketplace.dart';
import 'package:egorka/model/locations.dart';
import 'package:egorka/model/marketplaces.dart';
import 'package:egorka/model/response_coast_base.dart';
import 'package:egorka/model/suggestions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui' as ui;
import 'package:egorka/model/point.dart' as pointModel;
import 'package:yandex_mapkit/yandex_mapkit.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchAddressBloc extends Bloc<SearchAddressEvent, SearchAddressState> {
  bool isPolilyne = false;
  MarketPlaces? marketPlaces;

  SearchAddressBloc() : super(SearchAddressStated()) {
    on<SearchAddress>(_searchAddress);
    on<SearchAddressClear>((event, emit) => _clearAddress());
    on<ChangeMapPosition>(_changeMapPosition);
    on<SearchMeEvent>((event, emit) => emit(FindMeState()));
    on<DeletePolilyneEvent>(_deletePolyline);
    on<JumpToPointEvent>((event, emit) => emit(JumpToPointState(event.point)));
    on<SearchAddressPolilyne>(_getPoliline);
    on<GetAddressPosition>(_getAddress);
    on<GetMarketPlaces>(_getMarketPlaces);
    on<EditPolilynesEvent>(_editPolilynes);
    on<MarketPlaceCalcEvent>(_calculateOrderMarketPlace);
  }

  void _calculateOrderMarketPlace(
      MarketPlaceCalcEvent event, Emitter<SearchAddressState> emit) async {
    emit(SearchLoading());
    isPolilyne = true;

    final fromIcon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset('assets/images/from.png', 90));
    final toIcon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset('assets/images/to.png', 90));

    DrivingSessionResult? drivingSessionResult;
    BicycleSessionResult? bicycleResultWithSession;
    try {
      DrivingResultWithSession? requestRoutes = YandexDriving.requestRoutes(
        points: [
          RequestPoint(
              point: Point(
                latitude: event.suggestionsStart.last!.point!.latitude,
                longitude: event.suggestionsStart.last!.point!.longitude,
              ),
              requestPointType: RequestPointType.wayPoint),
          RequestPoint(
              point: Point(
                latitude: event.suggestionsEnd.last!.point!.latitude,
                longitude: event.suggestionsEnd.last!.point!.longitude,
              ),
              requestPointType: RequestPointType.wayPoint),
        ],
        drivingOptions: const DrivingOptions(),
      );
      BicycleResultWithSession? requestRoutesBicycle =
          YandexBicycle.requestRoutes(
        points: [
          RequestPoint(
              point: Point(
                latitude: event.suggestionsStart.last!.point!.latitude,
                longitude: event.suggestionsStart.last!.point!.longitude,
              ),
              requestPointType: RequestPointType.wayPoint),
          RequestPoint(
              point: Point(
                latitude: event.suggestionsEnd.last!.point!.latitude,
                longitude: event.suggestionsEnd.last!.point!.longitude,
              ),
              requestPointType: RequestPointType.wayPoint),
        ],
        bicycleVehicleType: BicycleVehicleType.bicycle,
      );

      drivingSessionResult = await requestRoutes.result;
      bicycleResultWithSession = await requestRoutesBicycle.result;
    } catch (e) {}
    if (drivingSessionResult != null) {
      var result = await Repository().getCoastMarketPlace(event.coast);
      emit(
        SearchAddressRoutePolilyne(
          drivingSessionResult,
          bicycleResultWithSession,
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
              icon: PlacemarkIcon.single(PlacemarkIconStyle(image: fromIcon)),
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
          result == null ? [] : [result],
        ),
      );
    }
  }

  void _getMarketPlaces(
      GetMarketPlaces event, Emitter<SearchAddressState> emit) async {
    var result = await Repository().getMarketplaces();
    if (result != null) {
      marketPlaces = result;
    }
  }

  void _editPolilynes(
      EditPolilynesEvent event, Emitter<SearchAddressState> emit) {
    emit(
      EditPolilynesState(
        directionsDrive: event.directions,
        directionsBicycle: event.directionsBicycle,
        markers: event.markers,
      ),
    );
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
      String address = '';
      String? errorAddress;

      SearchResultWithSession adress = YandexSearch.searchByPoint(
        point: Point(
          latitude: event.lat,
          longitude: event.lon,
        ),
        searchOptions: const SearchOptions(),
      );
      final value = await adress.result;

      address = value.items?.first.name ?? '';

      final house = value.items!.first.toponymMetadata?.address
          .addressComponents[SearchComponentKind.house];

      if (house == null) {
        errorAddress = 'ошибка';
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

      String address = '';
      String? errorAddress;

      SearchResultWithSession adress = YandexSearch.searchByPoint(
        point: Point(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
        searchOptions: const SearchOptions(),
      );
      final value = await adress.result;

      address = value.items?.first.name ?? '';

      final house = value.items?.first.toponymMetadata?.address
          .addressComponents[SearchComponentKind.house];

      if (house == null) {
        errorAddress = 'Ошибка';
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

    final fromIcon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset('assets/images/from.png', 90));
    final toIcon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset('assets/images/to.png', 90));

    DrivingSessionResult? drivingSessionResult;
    BicycleSessionResult? bicycleResultWithSession;
    try {
      DrivingResultWithSession? requestRoutes = YandexDriving.requestRoutes(
        points: [
          RequestPoint(
              point: Point(
                latitude: event.suggestionsStart.last!.point!.latitude,
                longitude: event.suggestionsStart.last!.point!.longitude,
              ),
              requestPointType: RequestPointType.wayPoint),
          RequestPoint(
              point: Point(
                latitude: event.suggestionsEnd.last!.point!.latitude,
                longitude: event.suggestionsEnd.last!.point!.longitude,
              ),
              requestPointType: RequestPointType.wayPoint),
        ],
        drivingOptions: const DrivingOptions(),
      );
      BicycleResultWithSession? requestRoutesBicycle =
          YandexBicycle.requestRoutes(
        points: [
          RequestPoint(
              point: Point(
                latitude: event.suggestionsStart.last!.point!.latitude,
                longitude: event.suggestionsStart.last!.point!.longitude,
              ),
              requestPointType: RequestPointType.wayPoint),
          RequestPoint(
              point: Point(
                latitude: event.suggestionsEnd.last!.point!.latitude,
                longitude: event.suggestionsEnd.last!.point!.longitude,
              ),
              requestPointType: RequestPointType.wayPoint),
        ],
        bicycleVehicleType: BicycleVehicleType.bicycle,
      );

      drivingSessionResult = await requestRoutes.result;
      bicycleResultWithSession = await requestRoutesBicycle.result;
    } catch (e) {}
    if (drivingSessionResult != null) {
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
            drivingSessionResult,
            bicycleResultWithSession,
            [
              PlacemarkMapObject(
                mapId: const MapObjectId('placemark_start'),
                point: Point(
                  latitude: drivingSessionResult
                      .routes!.first.geometry.first.latitude,
                  longitude: drivingSessionResult
                      .routes!.first.geometry.first.longitude,
                ),
                opacity: 1,
                icon: PlacemarkIcon.single(PlacemarkIconStyle(image: fromIcon)),
              ),
              PlacemarkMapObject(
                mapId: const MapObjectId('placemark_end'),
                point: Point(
                  latitude:
                      drivingSessionResult.routes!.first.geometry.last.latitude,
                  longitude: drivingSessionResult
                      .routes!.first.geometry.last.longitude,
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
