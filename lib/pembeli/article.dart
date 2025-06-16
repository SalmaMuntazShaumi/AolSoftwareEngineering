// lib/general/article.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compwaste/custom/article_card.dart';
import 'package:compwaste/custom/searchBar.dart';
import 'package:compwaste/helper/screen_utils.dart';
import 'package:flutter/material.dart';

class ArticlePage extends StatefulWidget {
  final void Function(Map<String, dynamic> article)? onArticleTap;
  const ArticlePage({super.key, this.onArticleTap});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  String user = 'Gina';

  @override
  Widget build(BuildContext context) {
    ScreenUtils.setScreenSizes(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white54,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Morning, $user',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Searchbar(),
                SizedBox(height: 10),
                TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blue,
                  tabs: const [
                    Tab(text: 'For You'),
                    Tab(text: 'Edukasi'),
                    Tab(text: 'Tips'),
                    Tab(text: 'Inspirasi'),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  child: TabBarView(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('articles').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Center(child: Text('No articles found.'));
                          }
                          final docs = snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              final data = docs[index].data() as Map<String, dynamic>;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0, left: 16),
                                child: GestureDetector(
                                  onTap: () {
                                    if (widget.onArticleTap != null) {
                                      widget.onArticleTap!({
                                        'title': data['title'] ?? 'No Title',
                                        'imagePath': data['url_image'] ?? 'https://inspektorat.palembang.go.id/assets/img/no-image.png',
                                        'author': data['author'] ?? 'Unknown',
                                        'publish_year': data['publish_year'] ?? 'Unknown',
                                        'desc': data['desc'] ?? 'No content available.',
                                      });
                                    }
                                  },
                                  child: ArticleCard(
                                    isHome: false,
                                    imageUrl: data['url_image'] ?? 'https://inspektorat.palembang.go.id/assets/img/no-image.png',
                                    url: data['url_article'] ?? '',
                                    title: data['title'] ?? '',
                                    date: data['publish_year'] ?? '',
                                    author: data['author'] ?? '',
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      Center(child: Text("Edukasi")),
                      Center(child: Text("Tips")),
                      Center(child: Text("Inspirasi")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}