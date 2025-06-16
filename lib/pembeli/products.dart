import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compwaste/custom/product_card.dart';
import 'package:compwaste/custom/searchBar.dart';
import 'package:compwaste/helper/screen_utils.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final String categoryLabel;
  final VoidCallback? onBack;
  const ProductPage({super.key, required this.categoryLabel, this.onBack});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    ScreenUtils.setScreenSizes(context);

    return SafeArea(
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
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No products found.'));
                }
                final allProducts = snapshot.data!.docs;
                final filteredProducts = allProducts.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return data['categories'] == widget.categoryLabel;
                }).toList();

                if (filteredProducts.isEmpty) {
                  return const Center(child: Text('No products found for this category.'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final data = filteredProducts[index].data() as Map<String, dynamic>;
                    return ProductCard(
                      imagePath: data['img'],
                      name: data['product_name'],
                      category: data['categories'],
                      price: data['price'],
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/productDetail',
                          arguments: {
                            'name': data['product_name'],
                            'imagePath': data['img'],
                            'price': data['price'],
                            'category': data['categories'],
                          },
                        );
                      },
                      onAddToCart: () {},
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}