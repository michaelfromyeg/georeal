import 'package:flutter/material.dart';
import 'package:georeal/features/geo_sphere/views/geo_spheres_view.dart';
import 'package:georeal/features/home/screens/home_screen.dart';
import 'package:georeal/global_variables.dart';

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
      floatingActionButton: FloatingActionButton(onPressed: () {}),
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
