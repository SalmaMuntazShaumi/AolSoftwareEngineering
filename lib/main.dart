import 'package:compwaste/general/HistoryDetail.dart';
import 'package:compwaste/general/login.dart';
import 'package:compwaste/general/notif.dart';
import 'package:compwaste/general/profile.dart';
import 'package:compwaste/general/splash_screen.dart';
import 'package:compwaste/pembeli/cart_screen.dart';
import 'package:compwaste/pembeli/detail_article.dart';
import 'package:compwaste/general/detail_products.dart';
import 'package:compwaste/role_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'Custom/bottom_navbar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Compwaste',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      routes: {
        '/cartPage': (context) => const CartPage(),
        '/role': (context) => const RolePage(),
        '/notification': (context) => const NotificationPage(),
        '/profile': (context) => const ProfilePage(),
        '/productDetail': (context) => const DetailProducts(),
        '/history_detail': (context) => const HistoryDetail(role: '',),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detailArticle') {
          final args = settings.arguments as Map<String, dynamic>? ?? {};
          return MaterialPageRoute(
            builder: (context) => DetailArticlePage(article: args),
          );
        }
        return null;
      },
    );
  }
}