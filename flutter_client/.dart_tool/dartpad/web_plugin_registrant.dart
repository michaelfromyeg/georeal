// Flutter web plugin registrant file.
//
// Generated file. Do not edit.
//

// @dart = 2.13
// ignore_for_file: type=lint

import 'package:google_maps_flutter_web/google_maps_flutter_web.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:location_web/location_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void registerPlugins([final Registrar? pluginRegistrar]) {
  final Registrar registrar = pluginRegistrar ?? webPluginRegistrar;
  GoogleMapsPlugin.registerWith(registrar);
  ImagePickerPlugin.registerWith(registrar);
  LocationWebPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
