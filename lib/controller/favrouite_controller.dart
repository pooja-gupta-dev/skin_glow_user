// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class FavoriteController extends GetxController {
//   var isFavorite = false.obs;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final User? user = FirebaseAuth.instance.currentUser;
//   var favoriteIds = <String>[].obs;
//
//   void checkFavorite(String productId) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//
//     final docSnapshot = await FirebaseFirestore.instance
//         .collection('favorites')
//         .doc(user.uid)
//         .collection('favoriteProducts')
//         .doc(productId)
//         .get();
//
//     isFavorite.value = docSnapshot.exists;
//   }
//
//   void toggleFavorite(String productId) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//
//     final docRef = FirebaseFirestore.instance
//         .collection('favorites')
//         .doc(user.uid)
//         .collection('favoriteProducts')
//         .doc(productId);
//
//     if (isFavorite.value) {
//       await docRef.delete();
//       isFavorite.value = false;
//       Get.snackbar("Removed","Product removed from favorites",
//           padding: const EdgeInsets.all(10),
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//     } else {
//       await docRef.set({'addedAt': Timestamp.now()});
//       isFavorite.value = true;
//       Get.snackbar("Added","Product added to favorites",
//           padding: const EdgeInsets.all(10),
//           backgroundColor: Colors.green,
//           colorText: Colors.white);
//     }
//   }
//
//   Stream<List<String>> getFavorites()
//   {
//     if (user == null) return Stream.value([]);
//     return _firestore
//         .collection('favorites')
//         .doc(user!.uid)
//         .collection('favoriteProducts')
//         .snapshots()
//         .map((snapshot) =>
//         snapshot.docs.map((doc) => doc.id).toList());
//   }
//
//   Future<void> removeFavorite(String productId) async {
//     if (user == null) return;
//     await _firestore
//         .collection('favorites')
//         .doc(user!.uid)
//         .collection('favoriteProducts')
//         .doc(productId)
//         .delete();
//   }
// }
