import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:georeal/features/gallery/widgets/photo_prompt.dart';
import 'package:georeal/features/geo_sphere/view_model/geo_sphere_view_model.dart';

class MapNavbar extends StatelessWidget {
  final GeoSphereViewModel model;
  final VoidCallback onMapPressed;
  final VoidCallback onFeedPressed;
  const MapNavbar(
      {super.key,
      required this.model,
      required this.onMapPressed,
      required this.onFeedPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white.withOpacity(0.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        spreadRadius: 4,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.camera_alt_outlined,
                  size: 28,
                  color: model.inGeoSphere
                      ? Colors.green
                      : const Color.fromARGB(255, 255, 255, 255),
                ),
              ],
            ),
            onTap: () => {
              log('${model.inGeoSphere}'),
              if (model.inGeoSphere)
                {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return PhotoPrompt(geosphere: model.geoSpheres.last);
                      })
                }
              else
                {}
            },
          ),
          Row(
            children: [
              TextButton(
                onPressed: onMapPressed,
                child: const Text(
                  "Map",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                height: MediaQuery.of(context).size.height * 0.05,
                width: 1,
                decoration: const BoxDecoration(color: Colors.white),
              ),
              TextButton(
                onPressed: onFeedPressed,
                child: const Text(
                  "Feed",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white.withOpacity(0.4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        spreadRadius: 4,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.add,
                  size: 28,
                  color: model.inGeoSphere
                      ? Colors.green
                      : const Color.fromARGB(255, 255, 255, 255),
                ),
              ],
            ),
            onTap: () => {
              log('${model.inGeoSphere}'),
              if (model.inGeoSphere)
                {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return PhotoPrompt(geosphere: model.geoSpheres.last);
                      })
                }
              else
                {}
            },
          ),
        ],
      ),
    );
  }
}
