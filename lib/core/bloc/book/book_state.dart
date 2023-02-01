part of 'book_bloc.dart';

class BookState {}

class BookStated extends BookState {}

class UpdateBook extends BookState {}

class LoadingState extends BookState {}

class GetAddress extends BookState {
  Address? address;
  GetAddress(this.address);
}
