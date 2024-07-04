import 'package:flutter/material.dart';
import 'package:tech/home.dart';
import 'package:tech/profile.dart';

class BottamNavigationBar extends StatefulWidget {
  const BottamNavigationBar({super.key});

  @override
  State<BottamNavigationBar> createState() => _BottamNavigationBarState();
}

class _BottamNavigationBarState extends State<BottamNavigationBar> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    Profile(),
    HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        // type: BottomNavigationBarType.shifting,
        backgroundColor: Color.fromARGB(255, 25, 17, 230),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.red,
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.brown,
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
            backgroundColor: Color.fromARGB(255, 18, 2, 7),
          ),
        ],
        selectedItemColor: Colors.amber[800],
        currentIndex: _selectedIndex,
        unselectedItemColor: Color.fromARGB(255, 3, 213, 161),
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
      body: _widgetOptions[_selectedIndex],
    );
  }
}
