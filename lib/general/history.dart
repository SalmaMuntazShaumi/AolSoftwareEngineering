import 'package:compwaste/custom/emission_summary_card.dart';
import 'package:compwaste/custom/waste_card.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  final String role;
  final void Function(Map<String, dynamic> history)? onHistoryTap;
  const HistoryPage({super.key, this.onHistoryTap, required this.role});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // Example dummy data for history
  final Map<String, dynamic> latestHistory = {
    'id': 1,
    'title': 'Order #1',
    'date': '2024-06-10',
    // Add more fields as needed
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Activity Summary', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
            widget.role == "pembeli" ? const SizedBox(height: 16) : SizedBox(),
            widget.role == "pembeli" ? EmissionSummaryCard() : SizedBox(),
            const SizedBox(height: 16),
            widget.role == "pembeli" ? Row(
              children: [
                SizedBox(
                  width: 120,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xffA3FFD6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/co2.png', height: 30),
                        SizedBox(height: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Emisi Karbon Global', textAlign: TextAlign.center),
                            const SizedBox(height: 4),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text('41,6', style: TextStyle(fontWeight: FontWeight.w500)),
                            ),
                            const SizedBox(height: 4),
                            Text('Miliar Ton'),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 150,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xff8576FF).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/love_earth.png', height: 30),
                          SizedBox(height: 12),
                          Center(
                            child: Text(
                              'Beli 2 produk lagi minggu ini untuk menyelamatkan 1 kg CO₂ tambahan',
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ) : SizedBox(),
            widget.role == "pembeli" ? const SizedBox(height: 16) : SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Pesanan Terbaru",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                GestureDetector(
                  onTap: () {
                    if (widget.onHistoryTap != null) {
                      widget.onHistoryTap!(latestHistory);
                    }
                  },
                  child: Text(">>>",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                )
              ],
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                if (widget.onHistoryTap != null) {
                  widget.onHistoryTap!(latestHistory);
                }
              },
              child: WasteCard(),
            ),
            widget.role == "penjual" ? Padding(
              padding: const EdgeInsets.only(top: 16, left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Pemasukan",
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text("Rp 1.000.000",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                ],
              ),
            ) : SizedBox(),

          ],
        ),
      ),
    );
  }
}