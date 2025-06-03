import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class EmissionSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFBEE7FF),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Image.asset('assets/earth.png', height: 28),
                  ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WOW, kamu\nmenyelamatkan alam!!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        '0,0000024%',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CircularPercentIndicator(
                    arcBackgroundColor: Colors.white,
                    arcType: ArcType.values[1],
                    radius: 60,
                    lineWidth: 10,
                    backgroundColor: Colors.transparent,
                    progressColor: Colors.white,
                    circularStrokeCap: CircularStrokeCap.square,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '1 TON',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          '100 Hari',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Emisi CO₂ berhasil dikurangi\nBumi lebih sehat karena aksimu!',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black87,
                    height: 1.5
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
