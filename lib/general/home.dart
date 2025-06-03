import 'package:compwaste/custom/article_card.dart';
import 'package:compwaste/custom/emission_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'label': 'Produk roti',
        'asset': 'assets/bakery.png',
        'color': Color(0xff7BC9FF),
      },
      {
        'label': 'Lemak',
        'asset': 'assets/oil.png',
        'color': Color(0xff1C1678),
      },
      {
        'label': 'Nasi',
        'asset': 'assets/rice.png',
        'color': Color(0xffA3FFD6),
      },
      {
        'label': 'Daging',
        'asset': 'assets/beef.png',
        'color': Color(0xff8576FF),
      },
      {
        'label': 'Buah dan Sayur',
        'asset': 'assets/vegetables.png',
        'color': Color(0xffA3FFD6),
      },
      {
        'label': 'Tulang',
        'asset': 'assets/zeroa.png',
        'color': Color(0xff7BC9FF),
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white54,
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
              const SizedBox(height: 32),
              EmissionCard(),
              const SizedBox(height: 30),
              const Text("Product Tersedia",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 14),

              SizedBox(
                height: 210,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _buildCategory(
                      category['label'],
                      category['asset'],
                      category['color'],
                    );
                  },
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
                    ArticleCard(
                        url: "https://www.example.com/article1",
                        imageUrl: "https://assetd.kompas.id/VwSHT6YNzpzvmbQaHCBgQKdpIfo=/fit-in/1024x720/filters:format(webp):quality(80)/https://asset.kgnewsroom.com/photo/pre/2022/11/16/6febad8a-a595-4914-91f9-c42a3177a386_jpeg.jpg",
                        title: "Menghitung Dampak Lingkungan dari sampah ...",
                        date: "14 Januari 2025",
                        author: "By Yanita Patiella",
                        widthSize: 200),
                    ArticleCard(
                        url: "https://www.example.com/article2",
                        imageUrl:
                            "https://akcdn.detik.net.id/visual/2020/08/10/tempat-pengelolaan-sampah-terpadu-tpst-bantar-gebang-di-bekasi-jawa-barat-senin-10820-cnbc-indonesiatri-susilo-1_169.jpeg?w=900&q=80",
                        title: "Pabrik di Jepang daur ulang limbah makanan ...",
                        date: "28 September 2024",
                        author: "By Rachel Nuver",
                        widthSize: 200),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategory(String label, String assets, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 30,
          child: Image.asset(assets, height: 32, width: 32, fit: BoxFit.cover),
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
}
