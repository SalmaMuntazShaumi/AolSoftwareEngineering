import 'package:compwaste/Custom/phone_field.dart';
import 'package:compwaste/controller.dart';
import 'package:compwaste/penjual/business_info.dart';
import 'login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final String role;
  const RegisterPage({super.key, required this.role});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pekerjaanController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  void _registerPembeli() async {
    setState(() => _isLoading = true);
    try {
      await signUp(
        _emailController.text,
        _passwordController.text,
        widget.role,
        name: _fullNameController.text,
        alamat: _addressController.text,
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(role: widget.role),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _registerPenjualAndNavigate() async {
    setState(() => _isLoading = true);
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match.')),
      );
      setState(() => _isLoading = false);
      return;
    }
    try {
      // Assign the result of signUp to tokenResult
      final tokenResult = await signUp(
        _emailController.text,
        _passwordController.text,
        widget.role,
        namalengkap: _fullNameController.text,
        notelp: _phoneController.text,
      );

      // Extract the token as a String
      final fetchedToken = tokenResult is String
          ? tokenResult
          : (tokenResult is Map && tokenResult['token'] is String
          ? tokenResult['token']
          : await fetchPenjualToken(_emailController.text, _passwordController.text));

      if (fetchedToken == null || fetchedToken is! String) throw Exception('Failed to retrieve token.');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BusinessInformation(
              role: widget.role,
              email: _emailController.text,
              password: _passwordController.text,
              fullName: _fullNameController.text,
              pekerjaan: widget.role,
              phone: _phoneController.text,
              token: fetchedToken,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage(role: widget.role)),
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
                  ),
                ),
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
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    label: Text('Nama Lengkap'),
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
                PhoneNumberField(controller: _phoneController),
                widget.role == "pembeli"
                    ? TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    label: Text('Alamat'),
                    labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.50), fontSize: 14),
                  ),
                )
                    : SizedBox.shrink(),
                const SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    label: Text('Kata Sandi'),
                    labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.50), fontSize: 14),
                  ),
                  obscureText: true,
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
                  obscureText: true,
                ),
                const SizedBox(height: 50),
                widget.role == "pembeli"
                    ? GestureDetector(
                  onTap: _isLoading ? null : _registerPembeli,
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
                )
                    : GestureDetector(
                  onTap: _isLoading ? null : _registerPenjualAndNavigate,
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