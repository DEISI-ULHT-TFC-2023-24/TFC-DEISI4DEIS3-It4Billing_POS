import 'package:flutter/material.dart';
import 'package:it4billing_pos/pages/profile.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Container(
      color: const Color(0xffffffff),
    ),
    Container(
      color: const Color(0xffffffff),
    ),
    Container(
      color: const Color(0xffffffff),
    ),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff00afe9),
        title: const Text(
          "IT4Billing",
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: SalomonBottomBar(
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xff6200ee),
          unselectedItemColor: const Color(0xff757575),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: _navBarItems),
    );
  }
}

final _navBarItems = [
  SalomonBottomBarItem(
    icon: const Icon(Icons.dashboard),
    title: const Text("Home"),
    selectedColor: Colors.purple,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.access_time),
    title: const Text("Turonos"),
    selectedColor: Colors.pink,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.search),
    title: const Text("Search"),
    selectedColor: Colors.orange,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.person),
    title: const Text("Prefile"),
    selectedColor: Colors.teal,
  ),
];
