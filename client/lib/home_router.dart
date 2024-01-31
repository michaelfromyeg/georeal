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
  final screens = [
    const HomeScreen(),
    const GeoSphereView(), /* FriendsScreen() */
  ];

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 0.5,
              color: Colors.grey,
            ),
          ),
        ),
        child: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildBottomNavItem(Icons.home, 'Home', 0),
              buildBottomNavItem(Icons.public, 'Geo Sphere', 1),
            ],
          ),
        ),
      ),
      body: screens[_page],
    );
  }

  Widget buildBottomNavItem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _page = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: _page == index
                  ? GlobalVariables.secondaryColor
                  : GlobalVariables.primaryColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: _page == index
                    ? GlobalVariables.secondaryColor
                    : GlobalVariables.primaryColor,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
