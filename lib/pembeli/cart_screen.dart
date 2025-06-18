import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:compwaste/custom/cart_card.dart';
import 'package:compwaste/pembeli/verif_cart.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> carts = [];
  double totalPrice = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    try {
      final fetchedCart = await fetchCart();
      setState(() {
        carts = fetchedCart;
        totalPrice = fetchedCart.fold(0.0, (sum, item) {
          final harga = double.tryParse(item['total_harga'] ?? '0') ?? 0.0;
          return sum + harga;
        });
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat keranjang: $e')),
      );
    }
  }

  Future<List<Map<String, dynamic>>> fetchCart() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token == null) throw Exception('No access token found');

    final response = await http.get(
      Uri.parse('https://compwaste.my.id/api/keranjang'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final keranjangs = data['keranjangs'];
      if (keranjangs is List) {
        return keranjangs.cast<Map<String, dynamic>>();
      }
    }
    throw Exception('Gagal mengambil data keranjang');
  }

  Future<void> createPesanan() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token tidak ditemukan')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('https://compwaste.my.id/api/pesanan'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Pesanan berhasil dibuat')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CheckoutPage()),
      );
    } else {
      if (data['invalid_products'] != null) {
        final invalid = data['invalid_products'] as List;
        final detail = invalid.map((e) {
          return "• ${e['product_name']} (diminta: ${e['requested']}, tersedia: ${e['available']})";
        }).join('\n');

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Pesanan Gagal'),
            content: Text('${data['message']}\n\n$detail'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              )
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Gagal membuat pesanan')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : carts.isEmpty
            ? const Center(child: Text('Keranjang kosong'))
            : ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  'Keranjang Belanja',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...carts.map((item) {
              final product = item['product'] ?? {};
              return CartCard(
                imagePath: product['foto'] != null
                    ? 'https://compwaste.my.id/storage/${product['foto']}'
                    : 'https://inspektorat.palembang.go.id/assets/img/no-image.png',
                title: product['nama'] ?? 'No Name',
                weight: '${item['total_berat'] ?? '0'} kg',
                pricePerKg:
                int.tryParse(product['harga_berat']?.split('.')?.first ?? '0') ?? 0,
                quantity: int.tryParse(item['banyak'] ?? '1') ?? 1,
                warning: '',
              );
            }).toList(),
            const SizedBox(height: 24),
            Text(
              'Total: Rp ${totalPrice.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: createPesanan,
          child: const Text('Pembayaran', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff1C1678),
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}
