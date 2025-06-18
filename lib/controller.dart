import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> signUp(
    String email,
    String password,
    String role, {
      String? name,        // pembeli
      String? alamat,      // pembeli
      String? namalengkap, // penjual
      String? notelp,      // penjual
    }) async {
  try {
    if (role == "pembeli") {
      final url = Uri.parse('https://compwaste.my.id/api/auth/user/register');
      var request = http.MultipartRequest('POST', url)
        ..fields['name'] = name ?? ''
        ..fields['email'] = email
        ..fields['password'] = password
        ..fields['alamat'] = alamat ?? '';
      final response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          return data;
        } else {
          // If no token, perform login to get token and user data
          final loginData = await signIn(email, password, "pembeli");
          return loginData;
        }
      } else {
        throw Exception('Failed to register pembeli: ${response.body}');
      }
    } else if (role == "penjual") {
      if (namalengkap == null || notelp == null) {
        throw Exception('namalengkap and notelp are required for penjual');
      }
      final url = Uri.parse('https://compwaste.my.id/api/auth/penjual/register');
      final body = {
        'namalengkap': namalengkap,
        'email': email,
        'notelp': notelp,
        'katasandi': password,
      };
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('Penjual registration failed: ${response.statusCode} ${response.body}');
        throw Exception('Failed to register penjual: ${response.body}');
      }
    } else {
      throw Exception('Invalid role: $role');
    }
  } catch (e) {
    print('Error during signUp: $e');
    rethrow;
  }
}

Future<Map<String, dynamic>> signIn(String email, String password, String role) async {
  try {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email dan password tidak boleh kosong.');
    }
    if (role == "pembeli") {
      final url = Uri.parse('https://compwaste.my.id/api/auth/user/login');
      var request = http.MultipartRequest('POST', url)
        ..fields['email'] = email
        ..fields['password'] = password;
      print('Pembeli login fields: ${request.fields}');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print('Pembeli login response: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // Normalize token key
        if (data['access_token'] != null) {
          data['token'] = data['access_token'];
        }
        return data;
      } else {
        throw Exception('Pembeli login failed: ${response.body}');
      }
    } else if (role == "penjual") {
      final url = Uri.parse('https://compwaste.my.id/api/auth/penjual/login');
      final body = {
        'email': email,
        'katasandi': password,
      };
      print('Penjual login body: $body');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      print('Penjual login response: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Penjual login failed: ${response.body}');
      }
    } else {
      throw Exception('Invalid role: $role');
    }
  } catch (e) {
    print("Error during signIn: $e");
    rethrow;
  }
}

Future<void> saveAccessToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('access_token', token);
}

Future<void> saveUserData({
  required String uid,
  required String email,
  required String role,
  required String fullName,
  required String pekerjaan,
  required String address,
  // Add more fields as needed
}) async {
  await FirebaseFirestore.instance.collection('users').doc(uid).set({
    'email': email,
    'role': role,
    'fullName': fullName,
    'pekerjaan': pekerjaan,
    'address': address,
    // Add more fields here
  }, SetOptions(merge: true));
}

Future<void> registerToko({
  required String token,
  required String namaResto,
  required String alamat,
  required String noTelp,
  required String jenisResto,
  required String tipeResto,
  bool? produkLayak,
  bool? produkTidakLayak,
  required String deskripsi,
}) async {
  final url = Uri.parse('https://compwaste.my.id/api/penjual/toko');
  final body = {
    'nama_resto': namaResto,
    'alamat': alamat,
    'no_telp': noTelp,
    'jenis_resto': jenisResto,
    'tipe_resto': tipeResto,
    'produk_layak': produkLayak,
    'produk_tidak_layak': produkTidakLayak,
    'deskripsi': deskripsi,
  };

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(body),
  );

  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception('Failed to register toko: ${response.body}');
  }
}

Future<void> createProduct({
  required String token, // token dari login
  required String nama,
  required String kategori,
  String? deskripsi,
  File? foto,
  required double hargaBerat,
  double? diskon,
  required double berat,
  required int totalBarang,
  required double totalBerat,
  required String tanggalProduksi,
  required String tanggalKadaluarsa,
  required String kondisi,
  String? syaratKetentuan,
  String? catatanTambahan,
}) async {
  var uri = Uri.parse('https://compwaste.my.id/api/penjual/produk');

  var request = http.MultipartRequest('POST', uri);
  request.headers['Authorization'] = 'Bearer $token';

  request.fields['nama'] = nama;
  request.fields['kategori'] = kategori;
  if (deskripsi != null) request.fields['deskripsi'] = deskripsi;
  request.fields['harga_berat'] = hargaBerat.toString();
  if (diskon != null) request.fields['diskon'] = diskon.toString();
  request.fields['berat'] = berat.toString();
  request.fields['total_barang'] = totalBarang.toString();
  request.fields['total_berat'] = totalBerat.toString();
  request.fields['tanggal_produksi'] = tanggalProduksi;
  request.fields['tanggal_kadaluarsa'] = tanggalKadaluarsa;
  request.fields['kondisi'] = kondisi;
  if (syaratKetentuan != null) request.fields['syarat_ketentuan'] = syaratKetentuan;
  if (catatanTambahan != null) request.fields['catatan_tambahan'] = catatanTambahan;

  if (foto != null) {
    request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
  }

  var response = await request.send();

  if (response.statusCode == 201) {
    final responseBody = await response.stream.bytesToString();
    final data = json.decode(responseBody);
    print('✅ Product created: ${data['product']['nama']}');
  } else {
    final responseBody = await response.stream.bytesToString();
    print('❌ Failed to create product: ${response.statusCode}');
    print(responseBody);
  }
}

Future<String> fetchPenjualToken(String email, String password) async {
  final url = Uri.parse('https://compwaste.my.id/api/auth/penjual/login');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'katasandi': password}),
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    final data = jsonDecode(response.body);
    if (data['token'] != null) {
      return data['token'];
    } else {
      throw Exception('Token not found in response');
    }
  } else {
    throw Exception('Failed to fetch token: ${response.body}');
  }
}

Future<XFile?> pickImage() async {
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
  return pickedImage;
}

Future<void> addArticles(String title, String author, String desc, String date, String url) {
  CollectionReference users = FirebaseFirestore.instance.collection('articles');
  // CollectionReference images = FirebaseFirestore.instance.collection('images');

  return users.add({
    'title': title,
    'author': author,
    'desc': desc,
    'publish_year': date,
    'url': url,
    // 'img': images.get()
  })
      .then((value) => print("Article added successfully!"))
      .catchError((error) => print("Failed to add article: $error"));
}

Future<void> fetchUsers() {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  return users.get()
      .then((QuerySnapshot snapshot) {
    snapshot.docs.forEach((doc) {
      print('${doc.id} => ${doc.data()}');
    });
  })
      .catchError((error) => print("Failed to fetch users: $error"));
}


Future<void> updateUserEmail(String userId, String newEmail) {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  return users.doc(userId).update({'email': newEmail})
      .then((value) => print("User email updated successfully!"))
      .catchError((error) => print("Failed to update user email: $error"));
}

Future<void> deleteUser(String userId) {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  return users.doc(userId).delete()
      .then((value) => print("User deleted successfully!"))
      .catchError((error) => print("Failed to delete user: $error"));
}