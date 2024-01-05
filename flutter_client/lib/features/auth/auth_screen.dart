import 'package:flutter/material.dart';
import 'package:georeal/features/auth/widgets/auth_text_field.dart';
import 'package:georeal/global_variables.dart';

enum Auth {
  signin,
  signup,
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signin;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
              if (_auth == Auth.signin)
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
                            controller: _emailController,
                            hintText: "Email",
                            isTextHidden: false),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AuthTextField(
                            controller: _passwordController,
                            hintText: "Password",
                            isTextHidden: true),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {},
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
                        onPressed: () {
                          setState(() {
                            _auth = Auth.signup;
                          });
                        },
                        child: const Text("Sign up with a new account"),
                      ),
                    ],
                  ),
                ),
              if (_auth == Auth.signup)
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
                            controller: _nameController,
                            hintText: "Name",
                            isTextHidden: false),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AuthTextField(
                            controller: _emailController,
                            hintText: "Email",
                            isTextHidden: false),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AuthTextField(
                            controller: _passwordController,
                            hintText: "Password",
                            isTextHidden: true),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 40),
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)))),
                          child: const Text("Sign Up"),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _auth = Auth.signin;
                          });
                        },
                        child: const Text("Sign in with an existing account"),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
