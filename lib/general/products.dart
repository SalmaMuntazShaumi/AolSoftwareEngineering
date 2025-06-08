import 'package:compwaste/custom/product_card.dart';
import 'package:compwaste/custom/searchBar.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final String categoryLabel;
  final VoidCallback? onBack;
  const ProductPage({super.key, required this.categoryLabel, this.onBack});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final Map<String, List<Map<String, dynamic>>> productsByCategory = {
    'Produk roti': [
      {
        'imagePath': 'assets/roti.png',
        'name': 'Roti Tawar',
        'category': 'Produk roti',
        'price': 2000,
      },
      {
        'imagePath': 'assets/roti.png',
        'name': 'Roti Manis',
        'category': 'Produk roti',
        'price': 2000,
      },
    ],
    'Lemak': [
      {
        'imagePath': 'assets/oil.png',
        'name': 'Minyak Goreng',
        'category': 'Lemak',
        'price': 1000,
      },
    ],
    // Add more categories and products as needed
  };

  @override
  Widget build(BuildContext context) {
    final products = productsByCategory[widget.categoryLabel] ?? [];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(flex: 4, child: Searchbar()),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: products.isEmpty
                  ? const Center(child: Text('No products found.'))
                  : GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    imagePath: product['imagePath'],
                    name: product['name'],
                    category: product['category'],
                    price: product['price'],
                    onTap: () {},
                    onAddToCart: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}