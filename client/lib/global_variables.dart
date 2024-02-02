import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GlobalVariables {

  static String get URI => dotenv.env['SERVER_URI'] ?? 'http://localhost:3000';
  static String get GOOGLE_API_KEY => dotenv.env['GOOGLE_API_KEY'] ?? '';

  // COLORS
  static const accentColor = Colors.red;
  static const backgroundColor = Color.fromRGBO(255, 255, 255, 1);
  static const foregroundColor = Color.fromRGBO(17, 45, 78, 1);
  static const primaryColor = Color.fromRGBO(2, 11, 30, 1);
  static const secondaryColor = Color.fromRGBO(63, 114, 175, 1);

  // FONTS
  static const headerStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static const headerStyleRegular = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );
  static const bodyStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
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
