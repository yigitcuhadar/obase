part of 'home_bloc.dart';

class HomeState extends Equatable {
  final int tabIndex;
  const HomeState({required this.tabIndex});

  @override
  List<Object> get props => [tabIndex];
}
