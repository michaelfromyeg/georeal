import 'package:georeal/constants/env_variables.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<void> login(String email, String password) async {
    var uri = Uri.parse('${EnvVariables.uri}/auth/login');
    var response = await http.post(
      uri,
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // TODO: Handle successful login
    } else {
      // TODO: Handle unsuccessful login
    }
  }

  static Future<void> register(
      String name, String email, String password) async {
    var uri = Uri.parse('${EnvVariables.uri}/auth/register');
    var response = await http.post(
      uri,
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // TODO: Handle successful registration
    } else {
      // TODO: Handle unsuccessful registration
    }
  }
}
