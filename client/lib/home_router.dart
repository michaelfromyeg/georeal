import 'package:flutter/material.dart';
import 'package:georeal/features/friends/view/friends_screen.dart';
import 'package:georeal/features/home/screens/home_screen.dart';
import 'package:georeal/features/profile/views/profile_screen.dart';
import 'package:georeal/global_variables.dart';

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
  }

  int _page = 0;

  final screens = [
    const HomeScreen(),
    const FriendsScreen(),
    const ProfileScreen(), /* FriendsScreen() */
  ];

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: GlobalVariables.backgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      /*floatingActionButton:  FloatingActionButton(
        foregroundColor: Colors.black, //Color.fromARGB(255, 3, 179, 0),
        backgroundColor: GlobalVariables.secondaryColor,
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
      ),*/
      bottomNavigationBar: BottomAppBar(
        height: 64,
        color: Colors.black,
        shape: const CircularNotchedRectangle(),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildBottomNavItem(Icons.map_outlined, 'Map', 0),
              buildBottomNavItem(Icons.search, 'Friends', 1),
              buildBottomNavItem(Icons.person, 'Profile', 2),
            ],
          ),
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
