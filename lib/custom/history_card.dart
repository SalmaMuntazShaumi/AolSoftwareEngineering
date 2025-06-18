import 'package:flutter/material.dart';

class HistoryCard extends StatefulWidget {
  final String docId;
  final String img, productName, price, status, role;
  final int qty;
  final VoidCallback? onKirim;
  final VoidCallback? onSelesai;

  const HistoryCard({
    super.key,
    required this.docId,
    required this.img,
    required this.productName,
    required this.qty,
    required this.price,
    required this.status,
    required this.role,
    this.onKirim,
    this.onSelesai,
  });

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  @override
  Widget build(BuildContext context) {
    final status = widget.status.toLowerCase();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: widget.img.isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.img,
                    height: 90,
                    width: 147,
                    fit: BoxFit.cover,
                  ),
                )
                    : const Icon(Icons.image, size: 50, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                    Text("${widget.qty} kg",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        )),
                    Text("Rp ${widget.price}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ))
                  ],
                ),
              )
            ],
          ),
          if (status != 'batal' && status != 'selesai') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        padding: const WidgetStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 4, horizontal: 38)),
                        side: const WidgetStatePropertyAll(BorderSide(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid)),
                        shape: WidgetStatePropertyAll(OutlinedBorder.lerp(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            RoundedRectangleBorder(),
                            0)),
                        backgroundColor: const WidgetStatePropertyAll(Colors.white)),
                    child: const Text('Batalkan', style: TextStyle(color: Colors.black)),
                  ),
                ),
                const SizedBox(width: 12),
                if (widget.role == "penjual" && status == "pesanan")
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.onKirim,
                      style: ButtonStyle(
                          padding: const WidgetStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 4, horizontal: 38)),
                          shape: WidgetStatePropertyAll(OutlinedBorder.lerp(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              RoundedRectangleBorder(),
                              0)),
                          backgroundColor: const WidgetStatePropertyAll(Color(0xff1C1678))),
                      child: const Text('Kirim', style: TextStyle(color: Colors.white)),
                    ),
                  )
                else if (widget.role == "pembeli" && status == "dikirim")
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.onSelesai,
                      style: ButtonStyle(
                          padding: const WidgetStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 4, horizontal: 38)),
                          shape: WidgetStatePropertyAll(OutlinedBorder.lerp(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              RoundedRectangleBorder(),
                              0)),
                          backgroundColor: const WidgetStatePropertyAll(Color(0xff1C1678))),
                      child: const Text('Selesai', style: TextStyle(color: Colors.white)),
                    ),
                  )
                else
                  const SizedBox(),
              ],
            ),
          ],
        ],
      ),
    );
  }
}