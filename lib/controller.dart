import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';


Future<void> signUp(
    String email,
    String password,
    String role, {
      required String fullName,
      required String pekerjaan,
      required String address,
      required String phone,
      String? jenis,         // Added
      String? restoName,     // Added
      // Add more fields as needed
    }) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    print("User registered");

    if (userCredential.user != null) {
      String uid = userCredential.user!.uid;
      final userData = {
        'role': role,
        'email': email,
        'fullName': fullName,
        'pekerjaan': pekerjaan,
        'address': address,
        'phone': phone,
      };

      if (jenis != null) userData['jenis'] = jenis;
      if (restoName != null) userData['restoName'] = restoName;

      await FirebaseFirestore.instance.collection('users').doc(uid).set(
        userData,
        SetOptions(merge: true),
      ).then((_) {
        print("User data saved in Firestore for UID: $uid");
      }).catchError((error) {
        print("Failed to save user data: $error");
      });
    }
  } catch (e) {
    print("Error : $e");
  }
}

Future<void> signIn(String email, String password, String role) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    print("User ${userCredential.user?.email} is signed in!");

    if (userCredential.user != null) {
      String uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set(
        {'role': role},
        SetOptions(merge: true),
      ).then((_) {
        print("User role updated to '$role' in Firestore for UID: $uid");
      }).catchError((error) {
        print("Failed to update user role: $error");
      });
    }
  } catch (e) {
    print("Error : $e");
    rethrow; // Add this line
  }
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

Future<XFile?> pickImage() async {
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
  return pickedImage;
}

// Future<void> uploadImageToFirestore() async {
//   XFile? pickedImage = await pickImage();
//   if (pickedImage != null) {
//     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     Reference storageReference = FirebaseStorage.instance.ref().child('images/$fileName');
//
//     UploadTask uploadTask = storageReference.putFile(File(pickedImage.path));
//     TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
//     String imageUrl = await taskSnapshot.ref.getDownloadURL();
//
//     await FirebaseFirestore.instance
//         .collection('images')
//         .add({'url': imageUrl});
//
//     print('Image uploaded successfully!');
//   } else {
//     print('No image picked!');
//   }
// }

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