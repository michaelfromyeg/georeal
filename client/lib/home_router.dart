import 'package:flutter/material.dart';
import 'package:georeal/features/geo_sphere/views/geo_spheres_view.dart';
import 'package:georeal/features/home/screens/home_screen.dart';
import 'package:georeal/global_variables.dart';

import 'features/geo_sphere/widgets/add_geo_sphere_modal.dart';

/// HomeRouter serves as the main navigation hub of the app

class HomeRouter extends StatefulWidget {
  const HomeRouter({super.key});

  @override
  _HomeRouterState createState() => _HomeRouterState();
}

class _HomeRouterState extends State<HomeRouter> {
  int _page = 0;
  final screens = [
    const HomeScreen(),
    const GeoSphereView(), /*FriendsScreen()*/
  ];

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            builder: (context) => Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: const AddGeoSphereModal(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: const Color.fromRGBO(29, 44, 77, 1),
      bottomNavigationBar: BottomAppBar(
        color: GlobalVariables.primaryColor,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _page = 0;
                });
              },
              icon: const Icon(Icons.home),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _page = 1;
                });
              },
              icon: const Icon(Icons.location_on_sharp),
            ),
          ],
        ),
      ),
      body: screens[_page],
    );
  }
}
