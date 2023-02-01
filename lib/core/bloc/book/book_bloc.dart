import 'package:egorka/core/network/repository.dart';
import 'package:egorka/model/address.dart';
import 'package:egorka/model/book_adresses.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  List<BookAdresses> books = [];
  BookBloc() : super(BookStated()) {
    on<LoadBooksEvent>(_loadBooks);
    on<LoadingEvent>(_loading);
    on<GetAddressEvent>(_loadAddress);
  }

  void _loadBooks(LoadBooksEvent event, Emitter<BookState> emit) async {
    List<BookAdresses>? res = await Repository().getListBookAdress();
    if (res != null) {
      books.clear();
      books.addAll(res);
    }
    emit(UpdateBook());
  }

  void _loading(LoadingEvent event, Emitter<BookState> emit) =>
      emit(LoadingState());

  void _loadAddress(GetAddressEvent event, Emitter<BookState> emit) async {
    emit(LoadingState());
    Address? res = await Repository().getAddress(event.value);
    emit(GetAddress(res));
  }
}
