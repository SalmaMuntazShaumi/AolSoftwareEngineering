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

  const BusinessInformation({
    super.key,
    required this.role,
    required this.email,
    required this.password,
    required this.fullName,
    required this.pekerjaan,
    required this.phone,
  });

  @override
  State<BusinessInformation> createState() => _BusinessInformationState();
}

class _BusinessInformationState extends State<BusinessInformation> {
  final TextEditingController _restoName = TextEditingController();
  final TextEditingController _restoDesc = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? jenis;

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
                Text('Jenis Restoran :', style: TextStyle(
                    color: Colors.black.withOpacity(0.50), fontSize: 14)),
                Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        selectedTileColor: Color(0xff1C1678),
                        title: Text('Individu'),
                        value: 'individu',
                        groupValue: jenis,
                        onChanged: (value) {
                          setState(() {
                            jenis = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Perusahaan'),
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
                  controller: _restoDesc,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    label: Text('Deskripsi Restoran'),
                    labelStyle  : TextStyle(
                        color: Colors.black.withOpacity(0.50), fontSize: 14),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                    onTap: () async{
                      await signUp(
                        widget.email,
                        widget.password,
                        widget.role,
                        fullName: widget.fullName,
                        pekerjaan: widget.pekerjaan,
                        address: _addressController.text,
                        phone: widget.phone,
                        jenis: jenis, // add this
                        restoName: _restoName.text, // add this
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(role: widget.role),
                        ),
                      );
                    },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff1C1678),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    height: 50,
                    child: const Center(
                      child: Text(
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