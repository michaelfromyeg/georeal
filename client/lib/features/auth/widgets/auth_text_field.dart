import 'package:flutter/material.dart';
import 'package:georeal/global_variables.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isTextHidden;
  const AuthTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.isTextHidden});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
          filled: true,
          fillColor: GlobalVariables.backgroundColor,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: GlobalVariables.secondaryColor,
            ),
          ),
          hintText: hintText,
          hintStyle:
              const TextStyle(color: Colors.white), // Adjust opacity as needed
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 255, 255, 255),
              ))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your $hintText';
        }
        return null;
      },
      obscureText: isTextHidden,
    );
  }
}
