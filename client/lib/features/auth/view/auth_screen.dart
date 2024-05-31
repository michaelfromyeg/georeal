import 'package:flutter/material.dart';
import 'package:georeal/features/auth/view_model/auth_view_model.dart';
import 'package:georeal/features/auth/widgets/auth_text_field.dart';
import 'package:georeal/global_variables.dart';
import 'package:georeal/home_router.dart';
import 'package:georeal/models/user.dart';
import 'package:georeal/providers/user_provider';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Consumer<AuthViewModel>(
              builder: (context, model, child) {
                return model.authMode == Auth.signin
                    ? _signInForm(context, model)
                    : _signUpForm(context, model);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _signInForm(BuildContext context, AuthViewModel model) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Sign In",
            style: GlobalVariables.headerStyle,
          ),
          const SizedBox(
            height: 16,
          ),
          AuthTextField(
            controller: model.emailController,
            hintText: "Email",
            isTextHidden: false,
          ),
          const SizedBox(
            height: 16,
          ),
          AuthTextField(
            controller: model.passwordController,
            hintText: "Password",
            isTextHidden: true,
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: GlobalVariables.secondaryColor),
              ),
              child: Center(
                child: Text(
                  "Sign In",
                  style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            onTap: () async {
              await _authenticateUser(context, model.login);
            },
          ),
          TextButton(
            onPressed: model.toggleAuthMode,
            child: const Text(
              "Don't have an Account? Sign up.",
              style: TextStyle(color: GlobalVariables.secondaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _signUpForm(BuildContext context, AuthViewModel model) {
    return Column(
      children: [
        const Text(
          "Sign Up",
          style: GlobalVariables.headerStyle,
        ),
        const SizedBox(
          height: 16,
        ),
        AuthTextField(
          controller: model.nameController,
          hintText: "Name",
          isTextHidden: false,
        ),
        const SizedBox(
          height: 16,
        ),
        AuthTextField(
          controller: model.usernameController,
          hintText: "Username",
          isTextHidden: false,
        ),
        const SizedBox(
          height: 16,
        ),
        AuthTextField(
          controller: model.emailController,
          hintText: "Email",
          isTextHidden: false,
        ),
        const SizedBox(
          height: 16,
        ),
        AuthTextField(
          controller: model.passwordController,
          hintText: "Password",
          isTextHidden: true,
        ),
        const SizedBox(
          height: 16,
        ),
        GestureDetector(
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width - 40,
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: GlobalVariables.secondaryColor),
            ),
            child: Center(
              child: Text(
                "Sign Up",
                style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          onTap: () async {
            await _authenticateUser(context, model.register);
          },
        ),
        TextButton(
          onPressed: model.toggleAuthMode,
          child: const Text(
            "Already have an Account? Log In.",
            style: TextStyle(color: GlobalVariables.secondaryColor),
          ),
        ),
      ],
    );
  }

  Future<void> _authenticateUser(BuildContext context, Function action) async {
    try {
      User? user = await action();
      if (context.mounted && user != null) {
        Provider.of<UserProvider>(context, listen: false).setUser(user);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeRouter()),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$error')),
        );
      }
    }
  }
}
