// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:georeal/features/friends/widgets/profile_layout.dart';
import 'package:georeal/features/geo_sphere/view_model/geo_sphere_view_model.dart';
import 'package:georeal/features/geo_sphere/widgets/geo_sphere_widget.dart';
import 'package:georeal/global_variables.dart';
import 'package:georeal/models/other_user.dart';
import 'package:georeal/providers/user_provider';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  OtherUser user;
  UserProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() =>
        Provider.of<GeoSphereViewModel>(context, listen: false)
            .fetchUserGeoSpheres(widget.user.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.backgroundColor,
        title: Text(
          widget.user.username,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: GlobalVariables.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            ProfileLayout(),
            Expanded(
              child: Consumer<GeoSphereViewModel>(
                builder: (context, geoSphereViewModel, child) {
                  // geoSphereViewModel.fetchUserGeoSpheres(user.id);
                  return ListView.builder(
                    itemCount: geoSphereViewModel.selectedUserGeoSpheres.length,
                    itemBuilder: (context, index) {
                      var geoSphere =
                          geoSphereViewModel.selectedUserGeoSpheres[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                        child: GeoSphereWidget(geoSphere: geoSphere),
                      );
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
