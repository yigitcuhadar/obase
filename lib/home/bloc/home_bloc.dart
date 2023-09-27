import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState(tabIndex: 0)) {
    on<HomeTabChangedEvent>((event, emit) {
      emit(HomeState(tabIndex: event.newTabIndex));
    });
  }
}
