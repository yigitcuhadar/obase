import 'package:equatable/equatable.dart';

class UserData extends Equatable {
  const UserData({
    required this.companyId,
  });

  final String companyId;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        companyId: json['companyId'] ?? "",
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'companyId': companyId,
      };
  @override
  List<Object?> get props => [companyId];
}
