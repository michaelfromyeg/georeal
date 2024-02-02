import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:georeal/constants/env_variables.dart';
import 'package:georeal/features/geo_sphere/views/geo_spheres_view.dart';
import 'package:georeal/features/home/screens/home_screen.dart';
import 'package:georeal/global_variables.dart';
import 'package:http/http.dart' as http;

Future<void> checkServerStatus() async {
  try {
    print("[georeal] Checking server");
    final response = await http.get(Uri.parse(EnvVariables.uri));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print('[georeal] Server status: ${data['status']}');
    } else {
      print('[georeal] Server error: ${response.statusCode}');
    }
  } catch (e) {
    print('[georeal] Error checking server status: $e');
  }
}

import 'features/geo_sphere/widgets/add_geo_sphere_modal.dart';

/// HomeRouter serves as the main navigation hub of the app

class HomeRouter extends StatefulWidget {
  const HomeRouter({super.key});

  @override
  _HomeRouterState createState() => _HomeRouterState();
}

class _HomeRouterState extends State<HomeRouter> {
  @override
  void initState() {
    super.initState();
    checkServerStatus();
  }

  int _page = 0;

  void _onItemTapped(int index) {
    setState(() {
      _page = index;
    });
  }

  final screens = [
    const HomeScreen(),
    const GeoSphereView(), /* FriendsScreen() */
  ];

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        foregroundColor: const Color.fromARGB(255, 3, 179, 0),
        backgroundColor: const Color.fromARGB(255, 10, 10, 10),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
        onPressed: () {
          showModalBottomSheet(
            useSafeArea: true,
            isScrollControlled: true,
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
      bottomNavigationBar: BottomAppBar(
        height: 64,
        color: const Color.fromARGB(255, 10, 10, 10),
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildBottomNavItem(Icons.map_outlined, 'Map', 0),
            buildBottomNavItem(Icons.language, 'Spaces', 1),
          ],
        ),
      ),
      body: screens[_page],
    );
  }

  Widget buildBottomNavItem(IconData icon, String label, int index) {
    // Inkwell adds touch interactivity to the icon
    return InkWell(
      onTap: () {
        setState(() {
          _page = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color:
                  _page == index ? GlobalVariables.secondaryColor : Colors.grey,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: _page == index
                    ? GlobalVariables.secondaryColor
                    : Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
