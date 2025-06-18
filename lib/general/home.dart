import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compwaste/custom/article_card.dart';
import 'package:compwaste/custom/emission_card.dart';
import 'package:compwaste/general/notif.dart';
import 'package:compwaste/general/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final void Function(String categoryLabel)? onCategoryTap;

  const HomePage({super.key, this.onCategoryTap});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? fullName;
  String? email;
  String? role;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        fullName = doc.data()?['fullName'] ?? 'User';
        email = user.email;
        role = doc.data()?['role'] ?? 'Guest';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> monthLabels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

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

    final List<Map<String, dynamic>> highlight = [
      {
        'label': 'Total Penjualan',
        'text': 'Rp 32.784.000',
        'asset': 'assets/dollar.png',
        'color': Color(0xffACFFAA),
        'border_color': Color(0xff329000)
      },
      {
        'label': 'Total Orderan',
        'text': '25.983',
        'asset': 'assets/box.png',
        'color': Color(0xffAAF7FF),
        'border_color': Color(0xff004793)
      },
      {
        'label': 'Followers',
        'text': '634.278',
        'asset': 'assets/person.png',
        'color': Color(0xffAEBC6FF),
        'border_color': Color(0xff750085)
      },
      {
        'label': 'Berat Penjualan',
        'text': '416 Kg',
        'asset': 'assets/leaf.png',
        'color': Color(0xffB3FFCA),
        'border_color': Color(0xff329000)
      }
    ];

    final List<Map<String, dynamic>> chartHighlights = highlight.map((h) {
      final text = h['text'].toString();
      final numeric = RegExp(r'\d+').allMatches(text.replaceAll('.', '')).map((m) => m.group(0)).join();
      return {
        ...h,
        'numeric': double.tryParse(numeric) ?? 0,
      };
    }).toList();

    final List<double> yValues = chartHighlights.map((h) => h['numeric'] as double).toList();

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
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Image.asset('assets/profile_icon.png', height: 24, width: 24),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProfilePage()),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Text("HI, ${fullName?.toUpperCase() ?? "User"}!",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500))
                    ],
                  ),
                  Row(
                    children: [
                      role == "pembeli" ? Icon(Icons.search) : IconButton(icon: Icon(Icons.notifications_outlined), onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NotificationPage()),
                        );
                      },),
                      role == "pembeli" ? IconButton(icon: Icon(Icons.notifications_outlined), onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NotificationPage()),
                        );
                      },) : IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              ),
              role == "pembeli" ? const SizedBox(height: 32) : const SizedBox.shrink(),
              role == "pembeli" ? EmissionCard() : SizedBox.shrink(),
              role == "pembeli" ? const SizedBox(height: 30) :  SizedBox.shrink(),
              role == "pembeli" ?const Text("Product Tersedia",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)) : SizedBox.shrink(),
              const SizedBox(height: 14),
              role == "pembeli" ? SizedBox(
                height: 210,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _buildCategory(
                        context,
                        category['label'],
                        category['asset'],
                        category['color'],
                        category['label']
                    );
                  },
                ),
              ) : GridView.builder(
                shrinkWrap: true,
                clipBehavior: Clip.none,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.5,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: highlight.length,
                itemBuilder: (context, index) {
                  final highlights = highlight[index];
                  return _buildHighlight(
                      context,
                      highlights['label'],
                      highlights['asset'],
                      highlights['color'],
                      highlights['text'],
                      highlights['border_color']
                  );
                },
              ),
              const SizedBox(height: 30),
              role == "pembeli" ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Berita Terbaru",
                      style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  Icon(Icons.more_horiz)
                ],
              ) : Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  color: Color(0xffF7FCFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Penjualan: (Bulan)",
                        style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    SizedBox(height: 8),
                    yValues.length > 1
                        ? SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toStringAsExponential(0),
                                    style: const TextStyle(fontSize: 10), // Set your desired small size
                                  );
                                },
                                reservedSize: 30, // Optionally reduce reserved space
                              ),
                            ),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                maxIncluded: true,
                                interval: 1,
                                showTitles: true,
                                reservedSize: 20,
                                getTitlesWidget: (value, meta) {
                                  int idx = value.toInt();
                                  // Use only as many month labels as data points
                                  if (idx >= 0 && idx < yValues.length && idx < monthLabels.length) {
                                    return Text(
                                      monthLabels[idx],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
                          ),
                          minX: 0,
                          maxX: (yValues.length - 1).toDouble(),
                          minY: yValues.reduce((a, b) => a < b ? a : b) - 10,
                          maxY: yValues.reduce((a, b) => a > b ? a : b) + 10,
                          lineBarsData: [
                            LineChartBarData(
                              spots: List.generate(
                                yValues.length,
                                    (i) => FlSpot(i.toDouble(), yValues[i]),
                              ),
                              isCurved: true,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(show: false),
                            )
                          ],
                        ),
                      ),
                    )
                        : const Text('Not enough data for chart'),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              role == "pembeli" ? SizedBox(
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
                        isHome: true),
                    ArticleCard(
                        url: "https://www.example.com/article2",
                        imageUrl:
                        "https://akcdn.detik.net.id/visual/2020/08/10/tempat-pengelolaan-sampah-terpadu-tpst-bantar-gebang-di-bekasi-jawa-barat-senin-10820-cnbc-indonesiatri-susilo-1_169.jpeg?w=900&q=80",
                        title: "Pabrik di Jepang daur ulang limbah makanan ...",
                        date: "28 September 2024",
                        author: "By Rachel Nuver",
                        isHome: true),
                  ],
                ),
              ) : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategory(BuildContext context, String label, String assets, Color color, String categoryLabel) {
    return GestureDetector(
      onTap: () {
        if (widget.onCategoryTap != null) {
          widget.onCategoryTap!(categoryLabel);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          CircleAvatar(
              backgroundColor: color,
              radius: 30,
              child: Image.asset(assets, height: 40, width: 40,)
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 32,
            child: Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlight(BuildContext context, String label, String assets, Color color, String text, Color borderColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              CircleAvatar(
                backgroundColor: color,
                radius: 10,
                child: Image.asset(assets, height: 14, width: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}