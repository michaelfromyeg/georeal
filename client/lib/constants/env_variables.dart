import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvVariables {
  static String googleApiKey = dotenv.env['GOOGLE_API_KEY']!;
  // static String uri = dotenv.env['SERVER_URI']!;
  static String uri = 'http://${dotenv.env['IP_ADDRESS']}:8000';
}
