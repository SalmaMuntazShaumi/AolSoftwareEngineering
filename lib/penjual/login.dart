import 'package:compwaste/role_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'register_screen.dart';

class LoginPagePembeli extends StatefulWidget {
  const LoginPagePembeli({super.key});

  @override
  State<LoginPagePembeli> createState() => _LoginPagePembeliState();
}

class _LoginPagePembeliState extends State<LoginPagePembeli> {
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
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
            children: [
              SizedBox(width: 370, child: Text('Selamat Datang Kembali! 👋', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24))),
              SizedBox(height: 15),
              Text('Masuk untuk memulai transaksi ramah lingkungan', style: TextStyle(color: Colors.black.withOpacity(0.50), fontSize:  14)),
              SizedBox(height: 60),
              TextField(decoration: InputDecoration(alignLabelWithHint: true, label: Text('Email'), labelStyle: TextStyle(color: Colors.black.withOpacity(0.50), fontSize: 14))),
              SizedBox(height: 15),
              TextField(decoration: InputDecoration(alignLabelWithHint: true, label: Text('Kata Sandi'), labelStyle: TextStyle(color: Colors.black.withOpacity(0.50), fontSize: 14)), keyboardType: TextInputType.visiblePassword),
              SizedBox(height: 50),
              GestureDetector(
                onTap: (){},
                child: Container(
                  decoration: BoxDecoration(color: Color(0xff1C1678), borderRadius: BorderRadius.circular(100)),
                    height: 50,
                    child: Center(child: Text('Masuk', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),))),
              ),
              SizedBox(height: 26),
              RichText(text: TextSpan( children: <TextSpan>[
                TextSpan(text: 'Belum punya akun?', style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.50))),
                TextSpan(text: ' Daftar di sini', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff0084FF), fontSize: 12), recognizer: TapGestureRecognizer()..onTap = () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPagePembeli()))),
              ],))
            ],
          ),
        ),
      ),
    );
  }
}
