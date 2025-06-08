import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget{
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: TopClipper(),
                clipBehavior: Clip.hardEdge,
                child: Container(
                  height: 270,
                  decoration: const BoxDecoration(
                    color: Color(0xff1C1678),
                    borderRadius: BorderRadius.only(
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(icon: Icon(Icons.arrow_back), color: Colors.white, onPressed: (){
                  Navigator.pop(context);
                },),
              ),
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/profile.png'),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'PT Agro Nusantara',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Industri pertanian',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const Text(
                      'sintari@gmail.com',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Container(
                  width: 560,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 3)
                    ],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size:16),
                          SizedBox(width: 8),
                          Text('Tanggal awal bergabung'),
                        ],
                      ),
                      SizedBox(height: 4),
                      Padding(
                        padding: EdgeInsets.only(left: 25),
                        child: Text('01/01/2025', style: TextStyle(color: Colors.grey)),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.edit_location, size: 16),
                          SizedBox(width: 8),
                          Text('Alamat'),
                        ],
                      ),
                      SizedBox(height: 4),
                      Padding(
                        padding: EdgeInsets.only(left: 25),
                        child: Text(
                          'Jalan Raya Bogor KM 30 No. 45, Cimanggis, Depok, Jawa Barat 16953',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _MenuButton(icon: Icons.settings, text: 'Pengaturan Notifikasi'),
                const SizedBox(height: 8),
                _MenuButton(icon: Icons.help, text: 'FAQ & Bantuan'),
                const SizedBox(height: 8),
                _MenuButton(icon: Icons.logout, text: 'Keluar dari Akun'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TopClipper extends CustomClipper<Path> {
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2, size.height + 20,
      size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}


class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String text;
  // final Color? color;

  const _MenuButton({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: Colors.black54),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}