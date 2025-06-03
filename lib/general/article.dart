import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compwaste/custom/article_card.dart';
import 'package:compwaste/helper/screen_utils.dart';
import 'package:flutter/material.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

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
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Morning, $user',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
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
                      // For You tab: Firestore articles
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
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: ArticleCard(
                                  imageUrl: data['url_image'] ?? 'https://inspektorat.palembang.go.id/assets/img/no-image.png',
                                  url: data['url_article'] ?? '',
                                  title: data['title'] ?? '',
                                  date: data['publish_year'] ?? '',
                                  author: data['author'] ?? '',
                                  widthSize: MediaQuery.of(context).size.width,
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