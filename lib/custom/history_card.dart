import 'package:flutter/material.dart';

class HistoryCard extends StatefulWidget {
  final String img, productName, price, status;
  final int qty;

  const HistoryCard({
    super.key,
    required this.img,
    required this.productName,
    required this.qty,
    required this.price,
    required this.status,
  });

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  @override
  Widget build(BuildContext context) {
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
          if (widget.status.toLowerCase() != 'batal') const SizedBox(height: 16),
          if (widget.status.toLowerCase() != 'batal')
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
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        padding: const WidgetStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 4, horizontal: 38)),
                        shape: WidgetStatePropertyAll(OutlinedBorder.lerp(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            RoundedRectangleBorder(),
                            0)),
                        backgroundColor: const WidgetStatePropertyAll(Color(0xff1C1678))),
                    child: const Text('Lacak', style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            )
        ],
      ),
    );
  }
}