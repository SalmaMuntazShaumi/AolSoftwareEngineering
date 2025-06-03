import 'package:compwaste/custom/emission_summary_card.dart';
import 'package:compwaste/custom/waste_card.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Activity Summary', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),),
            const SizedBox(height: 16),
            EmissionSummaryCard(),
            const SizedBox(height: 16),
            WasteCard()
          ],
        ),
      ),
    );
  }
}
