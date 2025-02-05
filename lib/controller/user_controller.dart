// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import '../model/user_model.dart';
// import '../view/screen/bottomNavigationn/bottom_navigtion.dart';
//
// class SignUpController extends GetxController {
//   var isLoading = false.obs;
//   var imageFile = Rx<File?>(null);
//   var userModel = UserModel(
//     uId: '',
//     username: '',
//     email: '',
//     phone: '',
//     userImg: '',
//     userAddress: '',
//
//   ).obs;
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//
//   Future<void> signUp(
//     String username,
//     String email,
//     String phone,
//     String password,
//     String city,
//   ) async {
//     try {
//       isLoading.value = true;
//
//       if (email.isEmpty ||
//           password.isEmpty ||
//           username.isEmpty ||
//           phone.isEmpty ||
//           city.isEmpty) {
//         Get.snackbar('Error', 'Please fill all the fields');
//         isLoading.value = false;
//         return;
//       }
//
//       if (!GetUtils.isEmail(email)) {
//         Get.snackbar('Error', 'Invalid email format');
//         isLoading.value = false;
//         return;
//       }
//
//       UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       String imageUrl = '';
//
//       if (imageFile.value != null) {
//         final SettableMetadata metadata = SettableMetadata(
//           contentType: 'image/jpeg',
//           cacheControl: 'public,max-age=3600',
//         );
//
//         String fileName = '${userCredential.user!.uid}.jpg';
//         Reference ref = _storage.ref().child('profile_images').child(fileName);
//
//         final UploadTask uploadTask = ref.putFile(imageFile.value!, metadata);
//
//         await uploadTask.whenComplete(() async {
//           try {
//             imageUrl = await ref.getDownloadURL();
//           } catch (e) {
//             Get.snackbar('Error', 'Failed to get image URL: ${e.toString()}');
//             imageUrl = '';
//           }
//         }).catchError((error) {
//           Get.snackbar('Error', 'Failed to upload image: ${error.toString()}');
//           imageUrl = '';
//         });
//       }
//
//       if (imageUrl.isEmpty) {
//         Get.snackbar('Error', 'Image upload failed or no image selected.');
//         isLoading.value = false;
//         return;
//       }
//
//       UserModel user = UserModel(
//         uId: userCredential.user!.uid,
//         username: username,
//         email: email,
//         phone: phone,
//         userImg: imageUrl,
//         userAddress: city,
//       );
//
//       await _firestore.collection('users').doc(user.uId).set(user.toMap());
//
//       userModel.value = user;
//
//       isLoading.value = false;
//
//       Get.snackbar('Success', 'User signed up successfully!');
//       Get.offAll(() => BottomNavExample());
//     } catch (e) {
//       isLoading.value = false;
//       Get.snackbar('Error', 'Error during sign up: ${e.toString()}');
//     }
//   }
//
//   Future<void> pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: source);
//     if (pickedFile != null) {
//       imageFile.value = File(pickedFile.path);
//     }
//     Get.back();
//   }
//
//   void showImagePickerOptions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.camera_alt, color: Colors.orange),
//                 title: const Text("Take a Photo"),
//                 onTap: () => pickImage(ImageSource.camera),
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo, color: Colors.orange),
//                 title: const Text("Select from Gallery"),
//                 onTap: () => pickImage(ImageSource.gallery),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> fetchUserData() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         DocumentSnapshot userDoc =
//             await _firestore.collection('users').doc(user.uid).get();
//         if (userDoc.exists) {
//           userModel.value =
//               UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
//         }
//       }
//     } catch (e) {
//       print("Error fetching user data: $e");
//     }
//   }
// }


import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../model/user_model.dart';
import '../view/screen/bottomNavigationn/bottom_navigtion.dart';

class SignUpController extends GetxController {
  var isLoading = false.obs;
  var imageFile = Rx<File?>(null);
  var userModel = UserModel(
    uId: '',
    username: '',
    email: '',
    phone: '',
    userImg: '',
    userAddress: '',
  ).obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;


  Future<void> signUp(
      String username,
      String email,
      String phone,
      String password,
      String city,
      ) async {
    try {
      isLoading.value = true;

      // 🛑 Validate Inputs
      if (email.isEmpty || password.isEmpty || username.isEmpty || phone.isEmpty || city.isEmpty) {
        Get.snackbar('Error', 'Please fill all the fields');
        isLoading.value = false;
        return;
      }

      if (!GetUtils.isEmail(email)) {
        Get.snackbar('Error', 'Invalid email format');
        isLoading.value = false;
        return;
      }


      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );


      String imageUrl = '';
      if (imageFile.value != null) {
        imageUrl = await uploadImage(userCredential.user!.uid, imageFile.value!);
      }

      // 📝 Save User Data in Firestore
      UserModel user = UserModel(
        uId: userCredential.user!.uid,
        username: username,
        email: email,
        phone: phone,
        userImg: imageUrl,
        userAddress: city,
      );

      await _firestore.collection('users').doc(user.uId).set(user.toMap());

      userModel.value = user;
      isLoading.value = false;

      // 🎉 Success Message & Navigation
      Get.snackbar('Success', 'User signed up successfully!');
      Get.offAll(() => BottomNavExample());
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Error during sign up: ${e.toString()}');
    }
  }

  /// 📌 **Upload Profile Image**
  Future<String> uploadImage(String uid, File imageFile) async {
    try {
      final ref = _storage.ref().child('profile_images/$uid.jpg');
      UploadTask uploadTask = ref.putFile(imageFile);

      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  /// 📌 **Pick Image from Camera or Gallery**
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  /// 📌 **Show Image Picker Options**
  void showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.orange),
                title: const Text("Take a Photo"),
                onTap: () {
                  Navigator.pop(context); // Close modal before picking image
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo, color: Colors.orange),
                title: const Text("Select from Gallery"),
                onTap: () {
                  Navigator.pop(context); // Close modal before picking image
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// 📌 **Fetch User Data from Firestore**
  Future<void> fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists && userDoc.data() != null) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

          userModel.value = UserModel(
            uId: data['uId'] ?? '',
            username: data['username'] ?? '',
            email: data['email'] ?? '',
            phone: data['phone'] ?? '',
            userImg: data['userImg'] ?? '',
            userAddress: data['userAddress'] ?? '',
          );
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }
}
