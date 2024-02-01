import 'package:flutter/material.dart';
import 'package:georeal/features/view_models/user_view_model.dart';
import 'package:georeal/home_router.dart';

/// handles all data and logic for the authentication process

enum Auth {
  signin,
  signup,
}

class AuthViewModel with ChangeNotifier {
  Auth _authMode = Auth.signin;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Auth get authMode => _authMode;
  TextEditingController get nameController => _nameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  void toggleAuthMode() {
    if (_authMode == Auth.signin) {
      _authMode = Auth.signup;
    } else {
      _authMode = Auth.signin;
    }
    notifyListeners();
  }

  Future<void> authenticate(BuildContext context) async {
    if (_authMode == Auth.signin) {
    } else {
      UserViewModel user = UserViewModel();
      Map<String, dynamic> userData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      };
      user.setUser(userData);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const HomeRouter()), // Assuming HomeRouter is your home widget
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
