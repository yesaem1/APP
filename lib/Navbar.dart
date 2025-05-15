import 'package:flutter/material.dart';
import 'package:kulkas_apps/HomeScreen.dart';
import 'package:kulkas_apps/kalender.dart';
import 'package:kulkas_apps/tes2.dart';

class navbar extends StatefulWidget {
  const navbar({Key? key}) : super(key: key);

  @override
  _navbarState createState() => _navbarState();
}

class _navbarState extends State<navbar> {
  int _selectedIndex = 0;

  final List<Widget> pages = [
    HomeScreen(),
    Kalender(),
    // Tes(),
  ]; // Kalender langsung digunakan di sini

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: pages[_selectedIndex], // Menampilkan halaman yang dipilih
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavbarItem(Icons.home_filled, 0),
                  _buildNavbarItem(Icons.calendar_today, 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavbarItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        _onItemTapped(index);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:
              _selectedIndex == index
                  ? Color.fromARGB(255, 96, 152, 72)
                  : Colors.transparent,
        ),
        child: Icon(
          icon,
          color:
              _selectedIndex == index
                  ? Colors.white
                  : Color.fromARGB(255, 74, 117, 56),
        ),
      ),
    );
  }
}
