import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:compwaste/controller.dart';
import 'package:compwaste/general/HistoryDetail.dart';
import 'package:compwaste/general/products.dart';
import 'package:compwaste/pembeli/article.dart';
import 'package:compwaste/general/chat.dart';
import 'package:compwaste/pembeli/detail_article.dart';
import 'package:compwaste/general/history.dart';
import 'package:compwaste/general/home.dart';
import 'package:compwaste/penjual/input_product.dart';

class CustomBottomNavBarPage extends StatefulWidget {
  final String role;
  final String userId;
  final String token;
  const CustomBottomNavBarPage({Key? key, required this.role, required this.userId, required this.token}) : super(key: key);

  @override
  _CustomBottomNavBarPageState createState() => _CustomBottomNavBarPageState();
}

class _CustomBottomNavBarPageState extends State<CustomBottomNavBarPage> {
  int _currentIndex = 0;
  String? _selectedCategoryLabel;
  Map<String, dynamic>? _selectedHistoryDetail;
  Map<String, dynamic>? _selectedArticle;
  String? _penjualToken;
  bool _loadingToken = false;

  @override
  void initState() {
    super.initState();
    if (widget.role == "penjual") {
      if (widget.token.isNotEmpty) {
        _penjualToken = widget.token;
      } else {
        _fetchPenjualToken();
      }
    }
  }

  Future<void> _fetchPenjualToken() async {
    setState(() => _loadingToken = true);
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('penjual_email') ?? '';
    final password = prefs.getString('penjual_password') ?? '';
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _penjualToken = null;
        _loadingToken = false;
      });
      return;
    }
    try {
      final token = await fetchPenjualToken(email, password);
      setState(() {
        _penjualToken = token;
        _loadingToken = false;
      });
    } catch (e) {
      setState(() => _loadingToken = false);
    }
  }

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
        role: widget.role,
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
        if (_loadingToken) {
          body = Center(child: CircularProgressIndicator());
        } else if (_penjualToken == null || _penjualToken!.isEmpty) {
          body = Center(child: Text("Token not found. Please login again."));
        } else {
          body = InputProduct(token: _penjualToken!);
        }
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
        role: widget.role,
      );
    } else if (_currentIndex == 2) {
      body = HistoryPage(
        onHistoryTap: (history) {
          setState(() {
            _selectedHistoryDetail = history;
          });
        },
        role: widget.role,
      );
    } else {
      body = Chat();
    }

    return Scaffold(
      backgroundColor: null,
      body: body,
      floatingActionButton: widget.role == "pembeli"
          ? FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/cartPage');
        },
        backgroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
        child: Icon(Icons.shopping_cart, color: Colors.black),
      )
          : null,
      floatingActionButtonLocation: widget.role == "pembeli" ? FloatingActionButtonLocation.centerDocked : null,
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
            mainAxisAlignment: widget.role == "pembeli" ? MainAxisAlignment.spaceBetween : MainAxisAlignment.spaceEvenly,
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