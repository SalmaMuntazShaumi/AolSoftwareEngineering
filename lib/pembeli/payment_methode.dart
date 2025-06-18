import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PaymentMethode extends StatefulWidget {
  @override
  State<PaymentMethode> createState() => _PaymentMethodeState();
}

class _PaymentMethodeState extends State<PaymentMethode> {
  String? _selectedMethod;
  String? _balance;
  bool _walletExpanded = true;
  int? _pesananId;
  int? _totalHarga;

  @override
  void initState() {
    super.initState();
    fetchBalance();
    fetchLatestUnpaidPesanan();
  }

  Future<void> fetchBalance() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token == null) return;
    final response = await http.get(
      Uri.parse('https://compwaste.my.id/api/user/balance'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _balance = data['balance'];
      });
    }
  }

  Future<void> fetchLatestUnpaidPesanan() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token == null) return;
    final response = await http.get(
      Uri.parse('https://compwaste.my.id/api/pesanan'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final pesanans = data['data'] as List<dynamic>? ?? [];
      final unpaid = pesanans.firstWhere(
            (p) => p['status'] == 'menunggu_pembayaran',
        orElse: () => null,
      );
      if (unpaid != null) {
        setState(() {
          _pesananId = unpaid['id'];
          _totalHarga = unpaid['total_harga'];
        });
      }
    }
  }

  Future<void> bayarPesanan() async {
    if (_pesananId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada pesanan yang perlu dibayar')),
      );
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token == null) return;
    final response = await http.patch(
      Uri.parse('https://compwaste.my.id/api/pesanan/$_pesananId/bayar'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Pembayaran berhasil')),
      );
      Navigator.pop(context, true);
    } else {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Gagal membayar pesanan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final eWalletOptions = [
      {
        "name": "Gopay",
        "price": _balance != null ? "Rp${_balance!.split('.').first}" : "Loading...",
        "icon": Icons.account_balance_wallet,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Metode Pembayaran", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: BackButton(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWarningBox(),
            SizedBox(height: 16),
            _buildWalletSection(eWalletOptions),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          height: 80,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Total\n${_totalHarga != null ? "Rp$_totalHarga" : "-"}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: bayarPesanan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[800],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text("Bayar", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWarningBox() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Tidak tersedia pembayaran di tempat saat ini.\nTolong pilih metode pembayaran yang lain",
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletSection(List<Map<String, dynamic>> eWalletOptions) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        initiallyExpanded: _walletExpanded,
        onExpansionChanged: (val) {
          setState(() {
            _walletExpanded = val;
          });
        },
        leading: Icon(Icons.account_balance_wallet_rounded, color: Colors.blue),
        title: Text("E-Wallet", style: TextStyle(fontWeight: FontWeight.bold)),
        children: eWalletOptions.map((e) {
          return RadioListTile(
            value: e["name"],
            groupValue: _selectedMethod,
            onChanged: (val) => setState(() => _selectedMethod = val.toString()),
            tileColor: Colors.white,
            title: Row(
              children: [
                Icon(e["icon"], color: Colors.blue),
                SizedBox(width: 8),
                Text(e["name"], style: TextStyle(fontWeight: FontWeight.bold)),
                Spacer(),
                Text(e["price"]),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}