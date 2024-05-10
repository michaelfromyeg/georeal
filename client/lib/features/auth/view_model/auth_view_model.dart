import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:georeal/features/auth/services/auth_service.dart';
import 'package:georeal/models/user.dart';

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
  User? user;

  Auth get authMode => _authMode;

  String? get errorMessage => _errorMessage;
  TextEditingController get nameController => _nameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  User get currentUser => user!;

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

  Future<User?> login() async {
    try {
      User? user = await AuthService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (user != null) {
        log('USER: ${user.toString()}');
        return user;
      } else {
        return null;
      }
    } catch (e) {
      log('SignIn failed: $e');
      rethrow;
    }
  }

  Future<User?> register() async {
    try {
      User? user = await AuthService.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );
      if (user != null) {
        return user;
      } else {
        return null;
      }
    } catch (e) {
      log('Register failed: $e');
      rethrow;
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
