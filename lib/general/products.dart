import 'dart:convert';
import 'package:compwaste/custom/product_card.dart';
import 'package:compwaste/custom/searchBar.dart';
import 'package:compwaste/helper/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductPage extends StatefulWidget {
  final String categoryLabel;
  final VoidCallback? onBack;
  const ProductPage({super.key, required this.categoryLabel, this.onBack});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<Map<String, dynamic>> addToCart({
    required int productId,
    required int banyak,
  }) async {
    final url = 'https://compwaste.my.id/api/keranjang';
    final accessToken = await getAccessToken();
    if (accessToken == null) {
      throw Exception('No access token found');
    }
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'product_id': productId,
        'banyak': banyak,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to add to cart: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final url =
        'https://compwaste.my.id/api/products/category/${widget.categoryLabel}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      // Adjust for your API's actual response structure
      if (decoded is Map && decoded.containsKey('data')) {
        final products = decoded['data']['data'] ?? decoded['data'];
        if (products is List) return products.cast<Map<String, dynamic>>();
        if (products is Map) return [products.cast<String, dynamic>()];
      }
      if (decoded is List) return decoded.cast<Map<String, dynamic>>();
      return [];
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtils.setScreenSizes(context);

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
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final products = snapshot.data ?? [];
                  if (products.isEmpty) {
                    return const Center(
                        child: Text('No products found for this category.'));
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final data = products[index];
                      final imageUrl = data['foto'] != null
                          ? 'https://compwaste.my.id/storage/${data['foto']}'
                          : 'https://inspektorat.palembang.go.id/assets/img/no-image.png';
                      return ProductCard(
                          imagePath: imageUrl,
                          name: data['nama'] ?? '',
                          category: data['kategori'] ?? '',
                          price: data['harga_berat']?.toString() ?? '',
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/productDetail',
                              arguments: {
                                'name': data['nama'],
                                'imagePath': imageUrl,
                                'price': data['harga_berat'],
                                'category': data['kategori'],
                              },
                            );
                          },
                          onAddToCart: () async {
                            try {
                              final result = await addToCart(productId: data['id'], banyak: 1);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result['message'] ?? 'Added to cart')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to add to cart: $e')),
                              );
                            }
                          }
                          );
                    },
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
