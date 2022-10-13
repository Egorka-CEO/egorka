part of 'search_bloc.dart';

abstract class SearchAddressEvent {}

class SearchAddress extends SearchAddressEvent {
  String value;

  SearchAddress(this.value);
}
