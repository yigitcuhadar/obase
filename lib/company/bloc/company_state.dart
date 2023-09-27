part of 'company_bloc.dart';

class CompanyState extends Equatable {
  final Company company;
  const CompanyState({
    required this.company,
  });

  @override
  List<Object?> get props => [company];
}
