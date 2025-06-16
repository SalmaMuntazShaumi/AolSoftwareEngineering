import 'package:compwaste/Custom/phone_field.dart';
import 'package:compwaste/controller.dart';
import 'login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RegisterPage extends StatefulWidget {
  final String role;
  const RegisterPage({super.key, required this.role});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _pekerjaanController = new TextEditingController();
  final TextEditingController _addressController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _confirmPasswordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage(role: widget.role,)),
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
                      'Daftar Sebagai ${widget.role}!',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                    )),
                const SizedBox(height: 20),
                SizedBox(
                  width: 350,
                  child: Text(
                    'Mari jadi bagian dari perubahan positif dan mulai berbelanja secara berkelanjutan!',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.50), fontSize: 14),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    label: Text('Nama Lengkap'),
                    labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.50), fontSize: 14),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _pekerjaanController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    label: Text('Pekarjaan'),
                    labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.50), fontSize: 14),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    label: Text('Email'),
                    labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.50), fontSize: 14),
                  ),
                ),
                const SizedBox(height: 15),
                PhoneNumberField(),
                widget.role == "pembeli" ? const SizedBox(height: 15) : SizedBox.shrink(),
                widget.role == "pembeli" ? TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    label: Text('Alamat'),
                    labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.50), fontSize: 14),
                  ),
                ) : SizedBox.shrink(),
                const SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    label: Text('Kata Sandi'),
                    labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.50), fontSize: 14),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    label: Text('Konfirmasi Kata Sandi'),
                    labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.50), fontSize: 14),
                  ),
                ),
                const SizedBox(height: 50),
                widget.role == "penjual" ? GestureDetector(
                  onTap: () {
                    setState(() {
                      signUp(_emailController.text, _passwordController.text, widget.role);
                    });
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
                ) : GestureDetector(
                  onTap: () {
                    setState(() {
                      MaterialPageRoute(builder: (context) => )
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff1C1678),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    height: 50,
                    child: const Center(
                      child: Text(
                        'Lanjut',
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
                                builder: (context) => LoginPage(role: widget.role,),
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
