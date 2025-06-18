import 'package:compwaste/controller.dart';
import 'package:compwaste/general/login.dart';
import 'package:compwaste/general/register_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BusinessInformation extends StatefulWidget {
  final String role;
  final String email;
  final String password;
  final String fullName;
  final String pekerjaan;
  final String phone;
  final String token;

  const BusinessInformation({
    super.key,
    required this.role,
    required this.email,
    required this.password,
    required this.fullName,
    required this.pekerjaan,
    required this.phone,
    required this.token,
  });

  @override
  State<BusinessInformation> createState() => _BusinessInformationState();
}

class _BusinessInformationState extends State<BusinessInformation> {
  final TextEditingController _restoName = TextEditingController();
  final TextEditingController _restoDesc = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _tipeRestoController = TextEditingController();

  String? jenis;
  bool produkLayak = false;
  bool produkTidakLayak = false;
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    _phoneController.text = widget.phone;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RegisterPage(role: widget.role)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  child: Text(
                    'Informasi Bisnis',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _restoName,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    label: Text('Nama Restoran'),
                    labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.50), fontSize: 14),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    label: Text('Alamat'),
                    labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.50), fontSize: 14),
                    suffixIcon: Icon(Icons.location_on, color: Colors.black.withOpacity(0.50)),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    label: Text('No. Telepon'),
                    labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.50), fontSize: 14),
                  ),
                ),
                const SizedBox(height: 15),
                Text('Jenis Restoran :', style: TextStyle(
                    color: Colors.black.withOpacity(0.50), fontSize: 14)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text('Individu', style: TextStyle(fontSize: 14),),
                        value: 'individu',
                        groupValue: jenis,
                        onChanged: (value) {
                          setState(() {
                            jenis = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Perusahaan', style: TextStyle(fontSize: 14),),
                        value: 'perusahaan',
                        groupValue: jenis,
                        onChanged: (value) {
                          setState(() {
                            jenis = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: _tipeRestoController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    label: Text('Tipe Restoran (misal: Café)'),
                    labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.50), fontSize: 14),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Checkbox(
                      value: produkLayak,
                      onChanged: (val) {
                        setState(() {
                          produkLayak = val ?? false;
                        });
                      },
                    ),
                    const Text('Produk Layak'),
                    const SizedBox(width: 20),
                    Checkbox(
                      value: produkTidakLayak,
                      onChanged: (val) {
                        setState(() {
                          produkTidakLayak = val ?? false;
                        });
                      },
                    ),
                    Expanded(child: const Text('Produk Tidak Layak')),
                  ],
                ),
                SizedBox(
                  height: 60,
                  child: TextField(
                    controller: _restoDesc,
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      label: Text('Deskripsi Restoran'),
                      labelStyle: TextStyle(
                          color: Colors.black.withOpacity(0.50), fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: _isLoading
                      ? null
                      : () async {
                    // Simple validation
                    if (_restoName.text.isEmpty ||
                        _addressController.text.isEmpty ||
                        _phoneController.text.isEmpty ||
                        jenis == null ||
                        _tipeRestoController.text.isEmpty ||
                        _restoDesc.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill all fields.')),
                      );
                      return;
                    }
                    setState(() => _isLoading = true);
                    try {
                      await registerToko(
                        token: widget.token,
                        namaResto: _restoName.text,
                        alamat: _addressController.text,
                        noTelp: _phoneController.text,
                        jenisResto: jenis ?? '',
                        tipeResto: _tipeRestoController.text,
                        produkLayak: produkLayak,
                        produkTidakLayak: produkTidakLayak,
                        deskripsi: _restoDesc.text,
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(role: widget.role),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Registration failed: $e')),
                      );
                    } finally {
                      setState(() => _isLoading = false);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff1C1678),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    height: 50,
                    child: Center(
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'Daftar',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Sudah punya akun?',
                        style: TextStyle(
                            fontSize: 12, color: Colors.black.withOpacity(0.50)),
                      ),
                      TextSpan(
                        text: ' Masuk di sini',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff0084FF),
                            fontSize: 12),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LoginPage(role: widget.role),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}