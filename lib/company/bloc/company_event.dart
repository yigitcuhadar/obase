part of 'company_bloc.dart';

class CompanyChangedEvent extends Equatable {
  final Company company;
  const CompanyChangedEvent({
    required this.company,
  });

  @override
  List<Object> get props => [company];
}
