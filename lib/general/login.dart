import 'package:compwaste/Custom/bottom_navbar.dart';
import 'package:compwaste/controller.dart';
import 'package:compwaste/role_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../general/register_screen.dart';

class LoginPage extends StatefulWidget {
  final String role;
  const LoginPage({super.key, required this.role});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email and password cannot be empty.')),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      final result = await signIn(
        _emailController.text,
        _passwordController.text,
        widget.role,
      );

      if (result == null || result['token'] == null) {
        throw Exception('Email or password is incorrect.');
      }

      String userId = result['userId']?.toString() ??
          result['sub']?.toString() ??
          _emailController.text;
      String token = result['token'].toString();

      // Save token to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', token);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => CustomBottomNavBarPage(
            role: widget.role,
            userId: userId,
            token: token,
          ),
        ),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Failed'),
          content: Text('Email or password is incorrect.\n$e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
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
            MaterialPageRoute(builder: (context) => RolePage()),
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
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
            children: [
              SizedBox(
                  width: 370,
                  child: Text('Selamat Datang Kembali! 👋',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 24))),
              SizedBox(height: 15),
              Text('Masuk untuk memulai transaksi ramah lingkungan',
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.50), fontSize: 14)),
              SizedBox(height: 60),
              TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      alignLabelWithHint: true,
                      label: Text('Email'),
                      labelStyle: TextStyle(
                          color: Colors.black.withOpacity(0.50), fontSize: 14))),
              SizedBox(height: 15),
              TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                      alignLabelWithHint: true,
                      label: Text('Kata Sandi'),
                      labelStyle: TextStyle(
                          color: Colors.black.withOpacity(0.50), fontSize: 14),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      )),
                  keyboardType: TextInputType.visiblePassword),
              SizedBox(height: 50),
              GestureDetector(
                onTap: _isLoading ? null : _login,
                child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xff1C1678),
                        borderRadius: BorderRadius.circular(100)),
                    height: 50,
                    child: Center(
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Masuk',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)))),
              ),
              SizedBox(height: 26),
              RichText(
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: 'Belum punya akun?',
                        style: TextStyle(
                            fontSize: 12, color: Colors.black.withOpacity(0.50))),
                    TextSpan(
                        text: ' Daftar di sini',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff0084FF),
                            fontSize: 12),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RegisterPage(role: widget.role)))),
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}