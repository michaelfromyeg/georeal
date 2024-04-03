import 'package:flutter/material.dart';
import 'package:georeal/features/auth/services/auth_service.dart';
import 'package:georeal/features/view_models/user_view_model.dart';

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
  String? _errorMessage;
  VoidCallback? onAuthSuccess;

  Auth get authMode => _authMode;

  String? get errorMessage => _errorMessage;
  TextEditingController get nameController => _nameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  void setErrorMessage(String? message) {
    _errorMessage = message;
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

  Future<bool> login() async {
    try {
      var response = await AuthService.login(
        _emailController.text,
        _passwordController.text,
      );
      _nameController.text = response['username'];
      onAuthSuccess?.call();
      return true;
    } catch (e) {
      setErrorMessage(e.toString());
      return false;
    }
  }

  Future<bool> register(UserViewModel user) async {
    try {
      await AuthService.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );
      onAuthSuccess?.call();
      return true;
    } catch (e) {
      setErrorMessage(e.toString());
      return false;
    }
  }

  void _setUser(UserViewModel user) {
    user.setUser({
      'name': _nameController.text,
      'email': _emailController.text,
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
