import 'package:flutter/material.dart';
import 'package:georeal/features/geo_sphere/services/geo_sphere_service.dart';
import 'package:georeal/home_router.dart';
import 'package:provider/provider.dart';

import 'features/geo_sphere/geo_sphere_view_model.dart';
// Replace with the actual path

void main() {
  GeoSphereService geoSphereService = GeoSphereService();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GeoSphereViewModel(geoSphereService),
        ),
        Provider<GeoSphereService>(
          create: (context) => geoSphereService,
        ),
      ],
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
      home: HomeRouter(),
    );
  }
}
