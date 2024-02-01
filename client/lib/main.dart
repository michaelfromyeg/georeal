import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:georeal/features/gallery/services/gallery_service.dart';
import 'package:georeal/features/geo_sphere/services/geo_sphere_service.dart';
import 'package:georeal/home_router.dart';
import 'package:provider/provider.dart';

import 'features/geo_sphere/view_model/geo_sphere_view_model.dart';
import 'features/location/location_view_model.dart';

Future main() async {
  await dotenv.load();

  WidgetsFlutterBinding.ensureInitialized();

  GalleryService galleryService = GalleryService();
  GeoSphereService geoSphereService = GeoSphereService(galleryService);
  LocationViewModel locationViewModel = LocationViewModel();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => locationViewModel,
        ),
        ChangeNotifierProvider(
          create: (context) =>
              GeoSphereViewModel(geoSphereService, locationViewModel),
        ),
        Provider<GeoSphereService>(
          create: (context) => geoSphereService,
        ),
        Provider<GalleryService>(
          create: (context) => galleryService,
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const HomeRouter(),
    );
  }
}
