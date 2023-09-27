import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

extension ColorExtension on Color {
  MaterialColor toMaterialColor() {
    final Map<int, Color> shades = {
      50: Color.fromARGB(alpha, red, green, blue),
      100: Color.fromARGB(alpha, red, green, blue),
      200: Color.fromARGB(alpha, red, green, blue),
      300: Color.fromARGB(alpha, red, green, blue),
      400: Color.fromARGB(alpha, red, green, blue),
      500: Color.fromARGB(alpha, red, green, blue),
      600: Color.fromARGB(alpha, red, green, blue),
      700: Color.fromARGB(alpha, red, green, blue),
      800: Color.fromARGB(alpha, red, green, blue),
      900: Color.fromARGB(alpha, red, green, blue),
    };
    return MaterialColor(value, shades);
  }
}

extension StringColorExtension on String {
  Color toColor() {
    var hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

class Company extends Equatable {
  static const List<Company> companies = [
    Company(
      '0',
      'OBASE',
      'https://i0.wp.com/halkarz.com/wp-content/uploads/2022/04/obase-bilgisayar-ve-danismanlik-hizm-tic-a-s.jpg?fit=740%2C418&ssl=1',
      '#2b73bd',
    ),
    Company(
      '1',
      'MİGROS',
      'https://upload.wikimedia.org/wikipedia/commons/0/07/MiGROS_Logo.svg',
      '#ed6827',
    ),
    Company(
      '2',
      'ŞOK',
      'https://upload.wikimedia.org/wikipedia/commons/c/c3/ŞOK_Market_logo.svg',
      '#fce001',
    ),
  ];

  final String id;
  final String name;
  final String photoUrl;
  final String primaryColor;

  const Company(
    this.id,
    this.name,
    this.photoUrl,
    this.primaryColor,
  );

  Company.fromJson(Map<String, dynamic> json)
      : this(
          json['id'],
          json['name'],
          json['photoUrl'],
          json['primaryColor'],
        );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'photoUrl': photoUrl,
        'primaryColor': primaryColor,
      };

  Company copyWith({
    String? id,
    String? name,
    String? photoUrl,
    String? primaryColor,
  }) {
    return Company(
      id ?? this.id,
      name ?? this.name,
      photoUrl ?? this.photoUrl,
      primaryColor ?? this.primaryColor,
    );
  }

  @override
  List<Object?> get props => [id, name, photoUrl, primaryColor];
}
