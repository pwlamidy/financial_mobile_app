import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key, this.selectedIndex = 0}) : super(key: key);

  final int selectedIndex;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Portfolio',
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: (currIndex) {
        if (currIndex == 0) {
          Navigator.pushNamed(context, "/dashboard");
        } else if (currIndex == 1) {
          Navigator.pushNamed(context, "/portfolio");
        }
      },
    );
  }
}
