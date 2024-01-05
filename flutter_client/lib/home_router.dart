import 'package:flutter/material.dart';
import 'package:georeal/features/friends/view/friends_screen.dart';
import 'package:georeal/features/home/screens/home_screen.dart';
import 'package:georeal/global_variables.dart';

class HomeRouter extends StatefulWidget {
  const HomeRouter({super.key});

  @override
  _HomeRouterState createState() => _HomeRouterState();
}

class _HomeRouterState extends State<HomeRouter> {
  int _page = 0;
  final screens = [const HomeScreen(), const FriendsScreen()];

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
              buildBottomNavItem(Icons.person, 'Friends', 1),
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
