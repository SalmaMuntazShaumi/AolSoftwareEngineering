import 'package:flutter/material.dart';

class DetailArticlePage extends StatelessWidget {
  final Map<String, dynamic> article;
  final VoidCallback? onBack;
  const DetailArticlePage({super.key, required this.article, this.onBack});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          _buildArticleImage(article['imagePath'], article),
          if (onBack != null)
            Positioned(
              top: 8,
              left: 8,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: onBack,
              ),
            ),
          _buildArticleDetailsOverlay(context, article),
        ],
      ),
    );
  }

  Widget _buildArticleImage(String? imagePath, Map<String, dynamic> article) {
    return Image.network(
      imagePath ?? '',
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey[300],
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }

  Widget _buildArticleDetailsOverlay(BuildContext context, Map<String, dynamic> article) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article['title'] ?? 'No Title',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(height: 8),
              Text(
                article['publish_year'] ?? '',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2D1E70),
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Text(
                  article['author'] ?? 'Unknown Author',
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                article['desc'] ?? 'No content available.',
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}