import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compwaste/custom/history_card.dart';
import 'package:compwaste/helper/screen_utils.dart';
import 'package:flutter/material.dart';

class HistoryDetail extends StatefulWidget {
  final String role;
  final VoidCallback? onBack;
  const HistoryDetail({super.key, this.onBack, required this.role});

  @override
  State<HistoryDetail> createState() => _HistoryDetailState();
}

class _HistoryDetailState extends State<HistoryDetail> {
  @override
  Widget build(BuildContext context) {
    ScreenUtils.setScreenSizes(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Riwayat Pesanan Kamu',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blue,
                  tabs: const [
                    Tab(text: 'Pesanan'),
                    Tab(text: 'Dikirim'),
                    Tab(text: 'Selesai'),
                    Tab(text: 'Dibatalkan'),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Pesanan tab (exclude status 'batal' and 'dikirm')
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('history').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Center(child: Text('No History found.'));
                          }
                          final docs = snapshot.data!.docs.where((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            final status = (data['status'] ?? '').toLowerCase();
                            return status != 'batal' && status != 'dikirm' && status != 'selesai';
                          }).toList();
                          if (docs.isEmpty) {
                            return Center(child: Text('No History found.'));
                          }
                          return ListView.builder(
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              final data = docs[index].data() as Map<String, dynamic>;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: HistoryCard(
                                    docId: docs[index].id,
                                    img: data['img'],
                                    productName: data['product_name'],
                                    qty: data['qty'],
                                    price: data['price'],
                                    status: data['status'] ?? '',
                                    role: widget.role,
                                    onKirim: widget.role == 'penjual'
                                        ? () async {
                                      await FirebaseFirestore.instance
                                          .collection('history')
                                          .doc(docs[index].id)
                                          .update({'status': 'dikirm'});
                                    }
                                        : null,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      // Dikirim tab (status == 'dikirm')
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('history').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Center(child: Text('No History found.'));
                          }
                          final docs = snapshot.data!.docs.where((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            return (data['status'] ?? '').toLowerCase() == 'dikirm';
                          }).toList();
                          if (docs.isEmpty) {
                            return Center(child: Text('Belum ada riwayat pesanan dikirim'));
                          }
                          return ListView.builder(
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              final data = docs[index].data() as Map<String, dynamic>;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: HistoryCard(
                                    docId: docs[index].id,
                                    img: data['img'],
                                    productName: data['product_name'],
                                    qty: data['qty'],
                                    price: data['price'],
                                    status: data['status'] ?? '',
                                    role: widget.role,
                                    onSelesai: widget.role == 'pembeli'
                                        ? () async {
                                      await FirebaseFirestore.instance
                                          .collection('history')
                                          .doc(docs[index].id)
                                          .update({'status': 'selesai'});
                                    }
                                        : null,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      // Selesai tab (status == 'selesai')
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('history').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Center(child: Text('No History found.'));
                          }
                          final docs = snapshot.data!.docs.where((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            return (data['status'] ?? '').toLowerCase() == 'selesai';
                          }).toList();
                          if (docs.isEmpty) {
                            return Center(child: Text('Belum ada riwayat pesanan selesai'));
                          }
                          return ListView.builder(
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              final data = docs[index].data() as Map<String, dynamic>;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: HistoryCard(
                                    docId: docs[index].id,
                                    img: data['img'],
                                    productName: data['product_name'],
                                    qty: data['qty'],
                                    price: data['price'],
                                    status: data['status'] ?? '',
                                    role: widget.role,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      // Dibatalkan tab (only status 'batal')
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('history').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Center(child: Text('No History found.'));
                          }
                          final docs = snapshot.data!.docs.where((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            return (data['status'] ?? '').toLowerCase() == 'batal';
                          }).toList();
                          if (docs.isEmpty) {
                            return Center(child: Text('Belum ada riwayat pesanan dibatalkan'));
                          }
                          return ListView.builder(
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              final data = docs[index].data() as Map<String, dynamic>;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: HistoryCard(
                                    docId: docs[index].id,
                                    img: data['img'],
                                    productName: data['product_name'],
                                    qty: data['qty'],
                                    price: data['price'],
                                    status: data['status'] ?? '',
                                    role: widget.role,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}