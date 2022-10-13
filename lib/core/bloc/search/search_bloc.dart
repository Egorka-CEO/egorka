import 'package:egorka/core/network/repository.dart';
import 'package:egorka/model/address.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchAddressBloc extends Bloc<SearchAddressEvent, SearchAddressState> {
  SearchAddressBloc() : super(SearchAddressStated()) {
    on<SearchAddress>((event, emit) => _searchAddress(event, emit));
    on<SearchAddressClear>((event, emit) => _clearAddress());
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

  void _clearAddress() => emit(SearchAddressStated());
}
