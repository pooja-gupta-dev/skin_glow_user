
import 'package:flutter/material.dart';
import 'package:user_app/view/screen/home/home_screen.dart';
import '../favorurite/favorite_screen.dart';
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';

class BottomNavExample extends StatefulWidget {
  @override
  _BottomNavExampleState createState() => _BottomNavExampleState();
}

class _BottomNavExampleState extends State<BottomNavExample> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    SearchScreen(),
    FavoritesPage(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.pink[400],
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  Icon(Icons.home, size: 30),
                  Container(
                    height: 5,
                    width: 20,
                    decoration: BoxDecoration(
                      color: _currentIndex == 0 ? Colors.pink[400] : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  Icon(Icons.search, size: 30),
                  Container(
                    height: 5,
                    width: 20,
                    decoration: BoxDecoration(
                      color: _currentIndex == 1 ? Colors.pink[400] : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  Icon(Icons.favorite, size: 30),
                  Container(
                    height: 5,
                    width: 20,
                    decoration: BoxDecoration(
                      color: _currentIndex == 2 ? Colors.pink[400] : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  Icon(Icons.account_circle, size: 30),
                  Container(
                    height: 5,
                    width: 20,
                    decoration: BoxDecoration(
                      color: _currentIndex == 3 ? Colors.pink[400] : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
