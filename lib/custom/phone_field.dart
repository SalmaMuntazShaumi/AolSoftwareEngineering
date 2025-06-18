import 'dart:async';
import 'package:flutter/material.dart';

class PhoneNumberField extends StatefulWidget {
  final TextEditingController controller;
  const PhoneNumberField({super.key, required this.controller});

  @override
  _PhoneNumberFieldState createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  String selectedCountryCode = '+62';
  late final TextEditingController _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController();
    _internalController.addListener(_updateFullPhoneNumber);
  }

  @override
  void dispose() {
    _internalController.removeListener(_updateFullPhoneNumber);
    _internalController.dispose();
    super.dispose();
  }

  void _updateFullPhoneNumber() {
    widget.controller.text = '$selectedCountryCode${_internalController.text}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
                    if (code == '+62')
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
                _updateFullPhoneNumber();
              });
            },
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _internalController,
            decoration: InputDecoration(
              alignLabelWithHint: true,
              label: Text('Masukan nomor telepon'),
              labelStyle: TextStyle(
                color: Colors.black.withOpacity(0.50),
                fontSize: 14,
              ),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}