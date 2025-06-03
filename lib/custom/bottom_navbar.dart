import 'package:compwaste/general/article.dart';
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
    ArticlePage(),
    HistoryPage(),
    Chat(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: null,
      body: _pages[_currentIndex],

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
        child: Icon(Icons.shopping_cart, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Inside your build method, replace the bottomNavigationBar:
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        child: BottomAppBar(
          shape: AutomaticNotchedShape(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              side: BorderSide(color: Colors.transparent, width: 1),
            ),
            StadiumBorder(
              side: BorderSide(color: Colors.transparent, width: 1),
            ),
          ),
          height: 70,
          notchMargin: 5,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildTabItem(icon: 'assets/home.png', index: 0),
                  SizedBox(width: 24),
                  _buildTabItem(icon: 'assets/article.png', index: 1),
                ],
              ),
              Row(
                children: [
                  _buildTabItem(icon: 'assets/history.png', index: 2),
                  SizedBox(width: 24),
                  _buildTabItem(icon: 'assets/chat.png', index: 3),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({required String icon, required int index}) {
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
        child: Image.asset(icon, height: 26, color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }
}
