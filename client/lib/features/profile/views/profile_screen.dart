import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:georeal/common/profile_photo.dart';
import 'package:georeal/features/geo_sphere/view_model/geo_sphere_view_model.dart';
import 'package:georeal/features/geo_sphere/widgets/geo_sphere_widget.dart';
import 'package:georeal/features/profile/views/friend_request_screen.dart';
import 'package:georeal/features/profile/views/profile_photo_edit.dart';
import 'package:georeal/global_variables.dart';
import 'package:georeal/providers/user_provider';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<GeoSphereViewModel>(context, listen: false)
            .fetchUserGeoSpheres(
                Provider.of<UserProvider>(context, listen: false).user!.id));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.backgroundColor,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FriendRequestScreen(),
                ),
              );
            },
            icon: const Icon(Icons.mail),
          ),
        ],
      ),
      backgroundColor: GlobalVariables.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  child: ProfilePhoto(
                    radius: 30,
                    image: Image.asset("assets/images/profile_photo.jpg"),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProfilePhotoEditScreen(
                        image: Image.asset("assets/images/profile_photo.jpg"),
                      );
                    }));
                  },
                ),
                Column(
                  children: [
                    Text(
                      user.numPosts.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Text("Memories"),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      user.numPlaces.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Text("Spaces"),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      user.numFriends.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Text("Friends"),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: Consumer<GeoSphereViewModel>(
                builder: (context, geoSphereViewModel, child) {
                  // geoSphereViewModel.fetchUserGeoSpheres(user.id);
                  return ListView.builder(
                    itemCount: geoSphereViewModel.selectedUserGeoSpheres.length,
                    itemBuilder: (context, index) {
                      log(geoSphereViewModel.selectedUserGeoSpheres.length
                          .toString());
                      var geoSphere =
                          geoSphereViewModel.selectedUserGeoSpheres[index];
                      if (geoSphereViewModel.selectedUserGeoSpheres.isEmpty) {
                        return const Center(
                          child: Text("No GeoSpheres"),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                          child: GeoSphereWidget(geoSphere: geoSphere),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
