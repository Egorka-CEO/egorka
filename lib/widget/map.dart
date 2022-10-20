import 'package:egorka/core/bloc/search/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatelessWidget {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(53.159646, 24.469827),
    zoom: 5,
  );

  const MapView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      padding: EdgeInsets.zero,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
      onCameraMove: (postion) {
        BlocProvider.of<SearchAddressBloc>(context)
            .add(ChangeMapPosition(postion.target));
      },
      initialCameraPosition: _kGooglePlex,
      mapType: MapType.normal,
      onMapCreated: (GoogleMapController controller) {},
    );
  }
}
