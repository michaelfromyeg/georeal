import 'package:flutter/material.dart';
import 'package:georeal/features/auth/auth_screen.dart';
import 'package:provider/provider.dart';

import 'features/add_geo_sphere/view_model/geo_sphere_view_model.dart';
// Replace with the actual path

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GeoSphereViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: AuthScreen(),
    );
  }
}
