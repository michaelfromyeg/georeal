import 'package:flutter_dotenv/flutter_dotenv.dart';

class GlobalVariables {
  static String google_api_key = dotenv.env['GOOGLE_API_KEY']!;
  static String uri = dotenv.env['SERVER_URI']!;
}
