import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

Future<void> signUp(String email, String password) async {
  try{
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    print("User registered");
  } catch(e){
    print("Error : $e");
  }
}

Future<void> signIn(String email, String password) async {
  try{
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    print("User ${userCredential.user?.email} is signed in!");
  } catch(e){
    print("Error : $e");
  }
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

