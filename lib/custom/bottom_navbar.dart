import 'package:compwaste/pembeli/article.dart';
import 'package:compwaste/general/chat.dart';
import 'package:compwaste/pembeli/detail_article.dart';
import 'package:compwaste/pembeli/history.dart';
import 'package:compwaste/general/home.dart';
import 'package:compwaste/pembeli/HistoryDetail.dart';
import 'package:compwaste/pembeli/products.dart';
import 'package:compwaste/penjual/input_product.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBarPage extends StatefulWidget {
  final String role;
  const CustomBottomNavBarPage({Key? key, required this.role}) : super(key: key);

  @override
  _CustomBottomNavBarPageState createState() => _CustomBottomNavBarPageState();
}

class _CustomBottomNavBarPageState extends State<CustomBottomNavBarPage> {
  int _currentIndex = 0;
  String? _selectedCategoryLabel;
  Map<String, dynamic>? _selectedHistoryDetail;
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
      body = Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                _selectedCategoryLabel = null;
              });
            },
          ),
          title: Text(_selectedCategoryLabel!),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: ProductPage(
          categoryLabel: _selectedCategoryLabel!,
          onBack: () {
            setState(() {
              _selectedCategoryLabel = null;
            });
          },
        ),
      );
    } else if (_currentIndex == 1) {
      if (widget.role == "penjual") {
        body = InputProduct();
      } else if (_selectedArticle == null) {
        body = ArticlePage(
          onArticleTap: (article) {
            setState(() {
              _selectedArticle = article;
            });
          },
        );
      } else {
        body = DetailArticlePage(
          article: _selectedArticle!,
          onBack: () {
            setState(() {
              _selectedArticle = null;
            });
          },
        );
      }
    } else if (_currentIndex == 2 && _selectedHistoryDetail != null) {
      body = HistoryDetail(
        onBack: () {
          setState(() {
            _selectedHistoryDetail = null;
          });
        },
      );
    } else if (_currentIndex == 2) {
      body = HistoryPage(
        onHistoryTap: (history) {
          setState(() {
            _selectedHistoryDetail = history;
          });
        },
      );
    } else {
      body = Chat(); // pass role if needed
    }

    return Scaffold(
      backgroundColor: null,
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
        child: widget.role == "pembeli" ? Icon(Icons.shopping_cart, color: Colors.black) : Image.asset('assets/market.png', height: 32,),
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
                  _buildTabItem(icon: widget.role == "pembeli" ? 'assets/article.png' : 'assets/prod_input.png', index: 1),
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
          } else if (index == 2) {
            _selectedHistoryDetail = null;
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