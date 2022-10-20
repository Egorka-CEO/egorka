part of 'search_bloc.dart';

abstract class SearchAddressState {}

class SearchAddressStated extends SearchAddressState {}

class SearchAddressLoading extends SearchAddressState {}

class SearchAddressSuccess extends SearchAddressState {
  Address? address;

  SearchAddressSuccess(this.address);
}

class ChangeAddressSuccess extends SearchAddressState {
  GeoData? geoData;

  ChangeAddressSuccess(this.geoData);
}

class SearchAddressFailed extends SearchAddressState {}
