import 'package:flutter/material.dart';
import 'package:georeal/features/auth/services/auth_service.dart';

/// handles all data and logic for the authentication process

enum Auth {
  signin,
  signup,
}

class AuthViewModel with ChangeNotifier {
  bool _loading = false;
  Auth _authMode = Auth.signin;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Auth get authMode => _authMode;
  bool get loading => _loading;
  TextEditingController get nameController => _nameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void toggleAuthMode() {
    if (_authMode == Auth.signin) {
      _authMode = Auth.signup;
    } else {
      _authMode = Auth.signin;
    }
    notifyListeners();
  }

  Future<void> authenticate(BuildContext context) async {
    setLoading(true);
    if (_authMode == Auth.signin) {
      var response = await AuthService.login(
        _emailController.text,
        _passwordController.text,
      );
    } else {
      var response = await AuthService.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );
    }
    setLoading(false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
