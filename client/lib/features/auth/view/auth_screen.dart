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
            body: SafeArea(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "Welcome to Geo Real",
                          style: GlobalVariables.headerStyle,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Icon(
                        Icons.public,
                        size: 200,
                      ),
                    ),
                    if (viewModel.authMode == Auth.signin)
                      Container(
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "Sign In",
                                  style: GlobalVariables.headerStyle,
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
                                  minimumSize: const Size(double.infinity, 40),
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.black,
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
                              child: const Text("Sign up with a new account"),
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
                              child: Center(
                                child: Text(
                                  "Sign Up",
                                  style: GlobalVariables.headerStyle,
                                ),
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
                                  final success = await viewModel.register(
                                      Provider.of<UserViewModel>(context));
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
                                  minimumSize: const Size(double.infinity, 40),
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.black,
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
                                  "Sign in with an existing account"),
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
