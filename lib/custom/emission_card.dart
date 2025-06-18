import 'package:flutter/material.dart';

class EmissionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: double.infinity,
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            margin: EdgeInsets.only(top:16),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 56, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '1000 kg',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Emisi CO₂ berhasil dikurangi',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 16),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: '100 Hari  ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: 'Bumi lebih sehat karena aksimu!',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),

        Positioned(
          top: -10,
          left: 0,
          right: 0,
          child: Center(
            child: Image.asset(
              'assets/earth.png',
              height: 80,
            ),
          ),
        ),
      ],
    );
  }
}
