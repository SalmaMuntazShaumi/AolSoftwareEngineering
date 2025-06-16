import 'package:compwaste/firebase_options.dart';
import 'package:compwaste/general/detail_article.dart';
import 'package:compwaste/general/detail_products.dart';
import 'package:compwaste/general/notif.dart';
import 'package:compwaste/general/profile.dart';
import 'package:compwaste/general/splash_screen.dart';
import 'package:compwaste/pembeli/HistoryDetail.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Custom/bottom_navbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
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
        '/notification': (context) => const NotificationPage(),
        '/profile': (context) => const ProfilePage(),
        '/productDetail': (context) => const DetailProducts(),
        '/history_detail': (context) => const HistoryDetail(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detailArticle') {
          final args = settings.arguments as Map<String, dynamic>? ?? {};
          return MaterialPageRoute(
            builder: (context) => DetailArticlePage(article: args),
          );
        }
        return null; // fallback to routes table
      },
    );
  }
}