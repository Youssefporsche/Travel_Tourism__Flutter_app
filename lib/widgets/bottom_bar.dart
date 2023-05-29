import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StylishBottomBar(
      items: [
        BottomBarItem(
          icon: const Icon(Icons.home),
          title: const Text(
            'Home',
            style: TextStyle(fontSize: 12),
          ),
          backgroundColor: Colors.blueAccent.shade200,
        ),
        // BottomNavigationBarItem(
        //     icon: Icon(Icons.favorite_rounded), label: 'Favorites'),
        BottomBarItem(
          icon: const Icon(Icons.add_circle_outline_rounded),
          title: const Text(
            'New Post',
            style: TextStyle(fontSize: 12),
          ),
          backgroundColor: Colors.greenAccent.shade700,
        ),
        BottomBarItem(
          icon: const Icon(Icons.notifications),
          title: const Text(
            'Notifications',
            style: TextStyle(fontSize: 10),
          ),
          backgroundColor: Colors.yellow.shade700,
        ),
        BottomBarItem(
          icon: Icon(Icons.favorite),
          title: Text(
            'Favorites',
            style: TextStyle(fontSize: 12),
          ),
          backgroundColor: Colors.red.shade700,
        ),
        // BottomNavigationBarItem(
        //     icon: Icon(Icons.account_circle_rounded), label: 'Profile'),
      ],
      currentIndex: _selectedIndex,
      option: BubbleBarOptions(
        barStyle: BubbleBarStyle.horizotnal,
        opacity: 0.4,
        iconSize: 24,
        inkEffect: true,
      ),
      onTap: _onItemTapped,
    );
  }
}
