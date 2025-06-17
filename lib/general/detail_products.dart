import 'package:flutter/material.dart';

class DetailProducts extends StatefulWidget {
  const DetailProducts({super.key});

  @override
  State<DetailProducts> createState() => _DetailProductsState();
}

class _DetailProductsState extends State<DetailProducts> {
  late final Map<String, dynamic> product;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    product = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProductImage(),
            Expanded(child: _buildProductDetails()),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
            "Detail Produk",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const Spacer(),
          const Icon(Icons.shopping_cart_outlined, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        product['imagePath'] ?? 'assets/default.png',
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildProductDetails() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text(
            product['name'] ?? 'No name',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Rp${product['price'] ?? 0}/kg',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.local_shipping, size: 16, color: Colors.blue),
              const SizedBox(width: 4),
              const Text(
                "Termasuk pengiriman cepat",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Minimal pembelian: ${product['minQty'] ?? 1} kg",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const Divider(height: 24),
          const Text(
            "Asal Produk:",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(
            product['category'] ?? 'Unknown',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            product['description'] ??
                "Tidak ada deskripsi produk.",
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFF1F1F1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          // Quantity Selector
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.remove_circle_outline),
              ),
              const Text(
                "10",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          const Spacer(),
          // Add to Cart Button
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart),
            label: const Text("Masukan"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3DD598),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          )
        ],
      ),
    );
  }
}