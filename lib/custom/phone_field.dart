import 'package:flutter/material.dart';

class PhoneNumberField extends StatefulWidget {
  @override
  _PhoneNumberFieldState createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  String selectedCountryCode = '+62';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Kode negara dengan dropdown
        Container(
          padding: const EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black.withOpacity(0.50)),
            ),
          ),
          child: DropdownButton<String>(
            value: selectedCountryCode,
            items: <String>['+62', '+1', '+91'].map((String code) {
              return DropdownMenuItem<String>(
                value: code,
                child: Row(
                  children: [
                    if (code == '+62') // Tampilkan bendera untuk +62
                      const Icon(Icons.flag, size: 16, color: Colors.red),
                    const SizedBox(width: 4),
                    Text(code),
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedCountryCode = newValue!;
              });
            },
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down),
          ),
        ),
        const SizedBox(width: 8),
        // Input nomor telepon
        Expanded(
          child: TextField(decoration: InputDecoration(alignLabelWithHint: true, label: Text('Masukan nomor telepon'), labelStyle: TextStyle(color: Colors.black.withOpacity(0.50), fontSize: 14)), keyboardType: TextInputType.number,),
        ),
      ],
    );
  }
}