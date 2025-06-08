import 'package:compwaste/general/home.dart';
import 'package:flutter/material.dart';

class ArticleCard extends StatefulWidget {
  final String title, date, author, url, imageUrl;
  final bool isHome;

  const ArticleCard({
    super.key,
    required this.title,
    required this.date,
    required this.author,
    required this.url,
    required this.imageUrl,
    this.isHome = true,
  });

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.isHome ? 250 : double.infinity,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              widget.imageUrl, // Replace with real image path
              height: 90,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.date,
                  style: TextStyle(fontSize: 10, color: Colors.black.withOpacity(0.5)),
                ),
                Text(
                  widget.author,
                  style: TextStyle(fontSize: 10, color: Colors.black.withOpacity(0.5)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
