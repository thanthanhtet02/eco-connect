import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: currentIndex,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.black,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 35),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add, size: 35),
          label: 'Create',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle, size: 35),
          label: 'Profile',
        ),
      ],
    );
  }
}
