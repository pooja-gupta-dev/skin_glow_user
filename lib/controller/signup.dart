// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../model/user_model.dart';  // Import your existing model
//
// class SignUpController extends GetxController {
//   var userModel = Rx<UserModel>(UserModel.empty());  // Default value of userModel
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchUserData();  // Fetch user data when the controller initializes
//   }
//
//   // Fetch user data from Firestore
//   Future<void> fetchUserData() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       try {
//         var userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//         if (userData.exists) {
//           userModel.value = UserModel.fromMap(userData.data()!);  // Update userModel with Firestore data
//         }
//       } catch (e) {
//         print("Error fetching user data: $e");
//       }
//     }
//   }
//
//   // Update user profile in Firestore
//   Future<void> updateUserProfile(Map<String, dynamic> data) async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       try {
//         await FirebaseFirestore.instance.collection('users').doc(user.uid).update(data);
//         fetchUserData();  // Refresh user data after update
//       } catch (e) {
//         print("Error updating user profile: $e");
//       }
//     }
//   }
// }
