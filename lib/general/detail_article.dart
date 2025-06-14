import 'package:flutter/material.dart';

class DetailArticlePage extends StatelessWidget {
  const DetailArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    final article = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildArticleImage(article['imagePath']),
            Expanded(child: _buildArticleDetails(article)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: const Color(0xFF2D1E70),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 12),
          const Text(
            "Detail Artikel",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildArticleImage(String? imagePath) {
    return imagePath != null
        ? ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imagePath,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    )
        : const SizedBox(height: 16);
  }

  Widget _buildArticleDetails(Map<String, dynamic> article) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text(
            article['title'] ?? 'No Title',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  article['author'] ?? 'Unknown Author',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                article['date'] ?? '',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const Divider(height: 24),
          Text(
            article['content'] ?? 'No content available.',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}