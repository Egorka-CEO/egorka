import 'package:egorka/core/network/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchAddressBloc extends Bloc<SearchAddressEvent, SearchAddressState> {
  SearchAddressBloc() : super(SearchAddressStated()) {
    on<SearchAddress>((event, emit) => _searchAddress(event, emit));
  }

  void _searchAddress(
      SearchAddress event, Emitter<SearchAddressState> emit) async {
    emit(SearchAddressLoading());
    if (event.value.isEmpty) {
      emit(SearchAddressStated());
    } else {
      var result = await Repository().getAddress('test', 'test');

      if (result != null) {
        emit(SearchAddressSuccess());
      } else {
        emit(SearchAddressFailed());
      }
    }
  }
}
