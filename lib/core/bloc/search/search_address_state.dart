part of 'search/search_adress_bloc.dart';

abstract class SearchAddressState {}

class SearchAddressLoading extends SearchAddressState {}

class SearchAddressSuccess extends SearchAddressState {}

class SearchAddressFailed extends SearchAddressState {}
