import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:georeal/features/auth/widgets/auth_text_field.dart';
import 'package:georeal/features/view_models/user_view_model.dart';
import 'package:georeal/global_variables.dart';
import 'package:georeal/home_router.dart';
import 'package:provider/provider.dart';

import '../view_model/auth_view_model.dart';

/// Authentication screen

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthViewModel(),
      child: Consumer<AuthViewModel>(
        builder: (context, viewModel, child) {
          viewModel.onAuthSuccess = () {
            Provider.of<UserViewModel>(context, listen: false).setUser({
              'name': viewModel.nameController.text,
              'email': viewModel.emailController.text,
            });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeRouter(),
              ),
            );
          };
          return Scaffold(
            backgroundColor: GlobalVariables.backgroundColor,
            body: SafeArea(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "Places",
                          style: GlobalVariables.headerStyle,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        "Caputre the moment, map your memories",
                        style: GlobalVariables.bodyStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    /*
                    const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Icon(
                        Icons.public,
                        size: 200,
                      ),
                    ),
                    */
                    if (viewModel.authMode == Auth.signin)
                      Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Text(
                                  "Sign In",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AuthTextField(
                                  controller: viewModel.emailController,
                                  hintText: "Email",
                                  isTextHidden: false),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AuthTextField(
                                  controller: viewModel.passwordController,
                                  hintText: "Password",
                                  isTextHidden: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  final success = await viewModel.login();

                                  if (success) {
                                  } else {
                                    if (viewModel.errorMessage != null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text(viewModel.errorMessage!),
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 45),
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                ),
                                child: const Text("Sign In"),
                              ),
                            ),
                            TextButton(
                              onPressed: viewModel.toggleAuthMode,
                              child: const Text(
                                "Sign up with a new account",
                                style: TextStyle(
                                    color: GlobalVariables.secondaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (viewModel.authMode == Auth.signup)
                      Container(
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Sign Up",
                                style: GlobalVariables.headerStyle,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AuthTextField(
                                  controller: viewModel.nameController,
                                  hintText: "Name",
                                  isTextHidden: false),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AuthTextField(
                                  controller: viewModel.nameController,
                                  hintText: "Username",
                                  isTextHidden: false),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AuthTextField(
                                  controller: viewModel.emailController,
                                  hintText: "Email",
                                  isTextHidden: false),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AuthTextField(
                                  controller: viewModel.passwordController,
                                  hintText: "Password",
                                  isTextHidden: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  log('Registering');
                                  final success = await viewModel.register(
                                      Provider.of<UserViewModel>(context,
                                          listen: false));
                                  if (success) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeRouter(),
                                        ));
                                  } else {
                                    if (viewModel.errorMessage != null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text(viewModel.errorMessage!),
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 45),
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                ),
                                child: const Text("Sign Up"),
                              ),
                            ),
                            TextButton(
                              onPressed: viewModel.toggleAuthMode,
                              child: const Text(
                                "Sign in with an existing account",
                                style: TextStyle(
                                    color: GlobalVariables.secondaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
