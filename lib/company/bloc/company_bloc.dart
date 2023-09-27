import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../model/company.dart';

part 'company_event.dart';
part 'company_state.dart';

class CompanyBloc extends HydratedBloc<CompanyChangedEvent, CompanyState> {
  CompanyBloc() : super(CompanyState(company: Company.companies[0])) {
    on<CompanyChangedEvent>(_handleCompanyChangedEvent);
  }

  void _handleCompanyChangedEvent(CompanyChangedEvent event, Emitter<CompanyState> emit) {
    emit(CompanyState(company: event.company));
  }

  @override
  CompanyState? fromJson(Map<String, dynamic> json) {
    return CompanyState(
      company: Company.fromJson(json['company']),
    );
  }

  @override
  Map<String, dynamic>? toJson(CompanyState state) {
    return {
      'company': state.company.toJson(),
    };
  }
}
