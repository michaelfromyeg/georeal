import 'package:flutter/material.dart';

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

  Future<void> authenticate() async {
    if (_authMode == Auth.signin) {
      // Handle sign in
    } else {
      // Handle sign up
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
