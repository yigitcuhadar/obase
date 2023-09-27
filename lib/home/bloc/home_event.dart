part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeTabChangedEvent extends HomeEvent {
  final int newTabIndex;
  const HomeTabChangedEvent({required this.newTabIndex});
  @override
  List<Object> get props => [newTabIndex];
}
