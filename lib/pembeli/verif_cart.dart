import 'package:compwaste/pembeli/payment_methode.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _step = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Verifikasi", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: BackButton(color: Colors.black),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStepTab("Pengiriman", 0),
              _buildStepTab("Pembayaran", 1),
              _buildStepTab("Riview", 2),
            ],
          ),
        ),
      ),
      body: _buildStepContent(),
    );
  }

  Widget _buildStepTab(String label, int index) {
    bool isActive = _step >= index;
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isActive ? Color(0xff1C1678) : Colors.black,
          ),
        ),
        SizedBox(height: 4),
        Container(
          height: 2,
          width: 60,
          color: isActive ? Color(0xff1C1678) : Colors.transparent,
        )
      ],
    );
  }

  Widget _buildStepContent() {
    if (_step == 0) {
      return _pengirimanContent();
    } else if (_step == 1) {
      return _pembayaranContent();
    } else {
      return _reviewContent();
    }
  }

  Widget _pengirimanContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Address", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("PT Agro Nusantara", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Jalan Raya Bogor KM 30 No. 45, Cimanggis, Depok, Jawa Barat 16953"),
                  Text("0812-3456-7890"),
                  Text("kontak@agronusantara.co.id"),
                ],
              ),
            ),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () => setState(() => _step = 1),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo[800],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text("Pembayaran", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _pembayaranContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping, color: Colors.blue),
              SizedBox(width: 8),
              Text("Perkiraan sampai 2-3 hari"),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Ringkasan Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Total Produk"), Text("Rp35.000")]),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Biaya Pengemasan"), Text("Rp25.000")]),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Biaya Pengiriman"), Text("Rp1.800")]),
                Divider(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text("Total Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Rp61.800", style: TextStyle(fontWeight: FontWeight.bold))
                ]),
              ],
            ),
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Metode Pembayaran"),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            tileColor: Colors.white,
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentMethode()),
              );
              if (result == true) {
                setState(() => _step = 2);
              }
            },
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            height: 80,
            child: Row(
              children: [
                Expanded(
                  child: Text("Total\nRp61.800", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  onPressed: () => setState(() => _step = 2),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[800],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: Text("Bayar", style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _reviewContent() {
    return Center(child: Text("Review Page (Not Implemented Yet)"));
  }
}