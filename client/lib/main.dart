import 'dart:developer';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:georeal/features/auth/view/auth_screen.dart';
import 'package:georeal/features/auth/view_model/auth_view_model.dart';
import 'package:georeal/features/friends/view_model/friend_view_model.dart';
import 'package:georeal/features/gallery/services/gallery_service.dart';
import 'package:georeal/features/gallery/view_model/gallery_view_model.dart';
import 'package:georeal/features/geo_sphere/services/geo_sphere_service.dart';
import 'package:georeal/features/profile/view_model/profile_view_model.dart';
import 'package:georeal/providers/user_provider';
import 'package:georeal/util/theme.dart';
import 'package:provider/provider.dart';

import 'features/geo_sphere/view_model/geo_sphere_view_model.dart';
import 'features/location/location_view_model.dart';

@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    log("[BackgroundFetch] Headless task timed-out: $taskId",
        name: 'BackgroundFetch');
    BackgroundFetch.finish(taskId);
    return;
  }
  log('[BackgroundFetch] Headless event received.', name: "BackhroundFetch");
  // Do your work here...
  BackgroundFetch.finish(taskId);
}

Future main() async {
  await dotenv.load();

  WidgetsFlutterBinding.ensureInitialized();

  GalleryService galleryService = GalleryService();
  GeoSphereService geoSphereService = GeoSphereService();
  LocationViewModel locationViewModel = LocationViewModel();
  GeoSphereViewModel geoSphereViewModel = GeoSphereViewModel(locationViewModel);
  geoSphereViewModel.startLocationChecks();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => locationViewModel,
        ),
        ChangeNotifierProvider(create: (context) => geoSphereViewModel),
        Provider<GeoSphereService>(
          create: (context) => geoSphereService,
        ),
        Provider<GalleryService>(
          create: (context) => galleryService,
        ),
        ChangeNotifierProvider(
          create: (context) => GalleryViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileViewModel(),
        ),
        ChangeNotifierProvider(create: (context) => FriendViewModel()),
      ],
      child: const MyApp(),
    ),
  );
  log('[BackgroundFetch] Registering headless task.', name: 'BackgroundFetch');
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _enabled = true;
  int _status = 0;
  final List<DateTime> _events = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    int status = await BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.NONE), (String taskId) async {
      // <-- Event handler
      // This is the fetch-event callback.
      log("[BackgroundFetch] Event received $taskId");
      setState(() {
        _events.insert(0, DateTime.now());
      });
      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      // <-- Task timeout handler.
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      log("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });
    log('[BackgroundFetch] configure success: $status');
    setState(() {
      _status = status;
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  void _onClickEnable(enabled) {
    setState(() {
      _enabled = enabled;
    });
    if (enabled) {
      BackgroundFetch.start().then((int status) {
        log('start success: $status', name: 'BackgroundFetch');
      }).catchError((e) {
        log('[BackgroundFetch] start FAILURE: $e');
      });
    } else {
      BackgroundFetch.stop().then((int status) {
        log('[BackgroundFetch] stop success: $status');
      });
    }
  }

  void _onClickStatus() async {
    int status = await BackgroundFetch.status;
    log('[BackgroundFetch] status: $status');
    setState(() {
      _status = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme.theme,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const AuthScreen(),
    );
  }
}
