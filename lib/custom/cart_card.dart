import 'package:flutter/material.dart';

class CartCard extends StatefulWidget {
  final String imagePath, title, weight, warning;
  final int pricePerKg, quantity;
  const CartCard({super.key,required this.imagePath,
    required this.title,
    required this.weight,
    required this.pricePerKg,
    required this.quantity,
    required this.warning,});

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  late int quantity;
  bool isChecked = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quantity = widget.quantity;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    widget.imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            widget.weight,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Rp${widget.pricePerKg}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Quantity Selector and Total Price
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  iconSize: 16,
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    setState(() {
                                      if (quantity > 1) quantity--;
                                    });
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(quantity.toString()),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  iconSize: 16,
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    setState(() {
                                      quantity++;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Rp ${quantity * widget.pricePerKg}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),

                // Checkbox
                Column(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (val) {
                        setState(() {
                          isChecked = val ?? false;
                        });
                      },
                      activeColor: Colors.deepPurple,
                    )
                  ],
                )
              ],
            ),
          ),
        ),

        // Warning text below card
        Container(
          margin: const EdgeInsets.only(top: 6),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orange),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Minimal pembelian ${widget.weight} kg",
                  style: const TextStyle(fontSize: 13),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
