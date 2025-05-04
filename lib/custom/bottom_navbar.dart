import 'package:compwaste/general/chat.dart';
import 'package:compwaste/general/history.dart';
import 'package:compwaste/general/home.dart';
import 'package:compwaste/general/products.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBarPage extends StatefulWidget {
  @override
  _CustomBottomNavBarPageState createState() => _CustomBottomNavBarPageState();
}

class _CustomBottomNavBarPageState extends State<CustomBottomNavBarPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    ProductPage(),
    HistoryPage(),
    Chat(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      // FAB di tengah
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
        child: Icon(Icons.shopping_cart, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // BottomAppBar dengan notch
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        // notchMargin: 8,
        elevation: 10,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Kiri
            Row(
              children: [
                _buildTabItem(icon: Icons.home, index: 0),
                SizedBox(width: 24),
                _buildTabItem(icon: Icons.article, index: 1),
              ],
            ),
            // Kanan
            Row(
              children: [
                _buildTabItem(icon: Icons.history, index: 2),
                SizedBox(width: 24),
                _buildTabItem(icon: Icons.chat, index: 3),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({required IconData icon, required int index}) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
          color: Color(0xFF8576FF),
          shape: BoxShape.circle,
        )
            : null,
        padding: EdgeInsets.all(10),
        child: Icon(
          size: 26,
          icon,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
