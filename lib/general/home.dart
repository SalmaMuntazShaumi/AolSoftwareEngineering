import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.person_outline),
                      SizedBox(width: 8),
                      Text("Hi, Gina!",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500))
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(width: 16),
                      Icon(Icons.notifications_outlined)
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),

              // Card Saldo
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xffB7E2FF).withOpacity(0.30),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black.withOpacity(0.20))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Rutinitas",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black38)),
                    const Text("RP3,546.819.61",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    // Container(
                    //   height: 12,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(20),
                    //     gradient: const LinearGradient(
                    //       colors: [
                    //         Color(0xff1E003E),
                    //         Color(0xff3D1D9B),
                    //         Color(0xff6797D4),
                    //         Color(0xffA1F3EF)
                    //       ],
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),

              const SizedBox(height: 30),
              const Text("Product Tersedia",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 14),

              SizedBox(
                height: 210,
                child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                    ),
                  children: [
                    _buildCategory("Produk roti", "🍞", Colors.lightBlue),
                    _buildCategory("Lemak", "🧈", Colors.deepPurpleAccent),
                    _buildCategory("Nasi", "🍚", Colors.greenAccent),
                    _buildCategory("Daging", "🥩", Colors.purple),
                    _buildCategory("Buah dan Sayur", "🥦", Colors.green),
                    _buildCategory("Tulang", "🦴", Colors.lightBlue),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Berita Terbaru",
                      style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  Icon(Icons.more_horiz)
                ],
              ),
              const SizedBox(height: 14),

              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildNewsCard(
                        "Menghitung Dampak Lingkungan dari sampah ...",
                        "14 Januari 2025",
                        "By Yanita Patiella"),
                    _buildNewsCard(
                        "Pabrik di Jepang daur ulang limbah makanan ...",
                        "28 September 2024",
                        "By Rachel Nuver"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategory(String label, String emoji, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 30,
          child: Text(emoji, style: const TextStyle(fontSize: 20)),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 70,
          child: Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12)),
        )
      ],
    );
  }

  Widget _buildNewsCard(String title, String date, String author) {
    return Container(
      width: 200,
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
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              'assets/article_image.png', // Ganti dengaqn gambar asli
              height: 90,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                const SizedBox(height: 6),
                Text(date,
                    style: TextStyle(
                        fontSize: 10, color: Colors.black.withOpacity(0.5))),
                Text(author,
                    style: TextStyle(
                        fontSize: 10, color: Colors.black.withOpacity(0.5))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
