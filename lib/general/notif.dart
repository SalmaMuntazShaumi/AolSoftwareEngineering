import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Notifikasi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              // Tab Bar
              const TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black,
                tabs: [
                  Tab(text: 'Semua'),
                  Tab(text: 'Rekomendasi'),
                ],
              ),
              const Divider(height: 1),
              // Tab View
              const Expanded(
                child: TabBarView(
                  children: [
                    NotificationList(),
                    Center(child: Text('Belum ada rekomendasi.')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  final List<Map<String, dynamic>> notifications = [
    {
      'isRead': false,
      'title': 'Transaksi berhasil!',
      'subtitle': 'Pesanan Anda sedang diproses dan akan segera dikirim.',
    },
    {
      'isRead': true,
      'title': 'Pesanan berhasil!',
      'subtitle': 'Produk Lemak Sapi Beku 5kg telah dikirim dan akan tiba dalam 2 hari.',
    },
    {
      'isRead': true,
      'title': 'Pengumuman',
      'subtitle': 'Mulai 1 Juli 2025, batas minimum transaksi adalah 15kg per item.',
    },
    {
      'isRead': true,
      'title': 'Invoice tersedia',
      'subtitle': 'Invoice untuk transaksi #INV24042537 kini bisa diunduh di halaman Riwayat.',
    },
    {
      'isRead': false,
      'title': '🆕 Produk Baru Tersedia!',
      'subtitle': 'Donat Tidak Layak Jual dari Toko Donat Cirebon kini tersedia – cek katalog sekarang!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notif = notifications[index];
        final iconPath = notif['isRead']
            ? 'assets/notification.png'
            : 'assets/notification_unread.png';

        return ListTile(
          leading: Image.asset(
            iconPath,
            width: 30,
            height: 30,
          ),
          title: Text(
            notif['title'],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(notif['subtitle']),
          tileColor: notif['isRead'] ? Colors.white : Colors.grey[200],
        );
      },
    );
  }
}
