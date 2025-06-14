import 'package:compwaste/general/article.dart';
import 'package:compwaste/general/chat.dart';
import 'package:compwaste/general/detail_article.dart';
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
  String? _selectedCategoryLabel;
  Map<String, dynamic>? _selectedArticle;

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_currentIndex == 0 && _selectedCategoryLabel == null) {
      body = HomePage(
        onCategoryTap: (categoryLabel) {
          setState(() {
            _selectedCategoryLabel = categoryLabel;
          });
        },
      );
    } else if (_currentIndex == 0 && _selectedCategoryLabel != null) {
      body = ProductPage(
        categoryLabel: _selectedCategoryLabel!,
        onBack: () {
          setState(() {
            _selectedCategoryLabel = null;
          });
        },
      );
    } else if (_currentIndex == 1 && _selectedArticle == null) {
      body = ArticlePage(
        onArticleTap: (article) {
          setState(() {
            _selectedArticle = article;
          });
        },
      );
    } else if (_currentIndex == 1 && _selectedArticle != null) {
      body = DetailArticlePage(
        article: _selectedArticle!,
        onBack: () {
          setState(() {
            _selectedArticle = null;
          });
        },
      );
    } else if (_currentIndex == 2) {
      body = HistoryPage();
    } else {
      body = Chat();
    }

    return Scaffold(
      backgroundColor: null,
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
        child: Icon(Icons.shopping_cart, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
          if (index == 0) {
            _selectedCategoryLabel = null;
          } else if (index == 1) {
            _selectedArticle = null;
          } else {
            _selectedCategoryLabel = null;
          }
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