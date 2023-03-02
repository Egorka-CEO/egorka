part of 'book_bloc.dart';

class BookEvent {}

class LoadBooksEvent extends BookEvent {}

class LoadingEvent extends BookEvent {}

class SuccessEvent extends BookEvent {}

class GetAddressEvent extends BookEvent {
  String value;

  GetAddressEvent(this.value);
}
