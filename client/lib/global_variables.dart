import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GlobalVariables {
  //static String get URI => dotenv.env['SERVER_URI'] ?? 'http://localhost:5000';
  // ignore: non_constant_identifier_names
  static String get URI => 'http://localhost:5000';

  // ignore: non_constant_identifier_names
  static String get GOOGLE_API_KEY => dotenv.env['GOOGLE_API_KEY'] ?? '';

  // COLORS
  static const accentColor = Colors.red;
  static const backgroundColor = Color.fromRGBO(14, 21, 33, 1);
  static const foregroundColor = Color.fromRGBO(33, 33, 33, 1);
  static const primaryColor = Color.fromRGBO(2, 11, 30, 1);
  static const secondaryColor = Color.fromRGBO(73, 140, 221, 1);

  // FONTS
  static const headerStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const headerStyleRegular = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );
  static const bodyStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const bodyStyleRegular = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );
  static const textStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static const textStyleRegular = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );
}
