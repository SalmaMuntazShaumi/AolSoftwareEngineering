import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String category;
  final String price;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.category,
    required this.price,
    this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  imagePath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      'https://inspektorat.palembang.go.id/assets/img/no-image.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp$price',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_shopping_cart, size: 20),
                        onPressed: onAddToCart,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}