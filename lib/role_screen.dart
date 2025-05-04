import 'package:compwaste/pembeli/Pages/login.dart';
import 'package:flutter/material.dart';

class RolePage extends StatefulWidget {
  const RolePage({super.key});

  @override
  State<RolePage> createState() => _RolePageState();
}

class _RolePageState extends State<RolePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 60),
            child: Column(
              children: [
                SizedBox(width: 368, child: Text('Mulai perjalanan Anda bersama kami!', style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.w600), textAlign: TextAlign.center,)),
                SizedBox(height: 26),
                Image.asset('assets/role.png', height: 212),
                SizedBox(height: 30),
                Text('Pilih peran Anda untuk menjadi bagian dari solusi berkelanjutan!', style: TextStyle(color: Colors.black.withOpacity(0.50)), textAlign: TextAlign.center),
                SizedBox(height: 32),
                SizedBox(
                  width: 230,
                  child: ElevatedButton(onPressed: () {
                    setState(() {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    });
                  }, child: Text('Pembeli'), style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff7BC9FF)), foregroundColor: MaterialStateProperty.all(Colors.black)), ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: 230,
                  child: ElevatedButton(onPressed: () {
                  }, child: const Text('Penjual'), style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff7BC9FF)), foregroundColor: MaterialStateProperty.all(Colors.black)),),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}