// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:user_app/view/screen/favorurite/favorite_screen.dart';
// import '../../../controller/user_controller.dart';
// import '../../login/login.dart';
// import '../cart/cart_screen.dart';
// import '../order/all_order_screen.dart';
// import '../order/editprofile_screen.dart';
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final SignUpController controller = Get.put(SignUpController());
//
//   @override
//   void initState() {
//     super.initState();
//     controller.fetchUserData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(
//             child: Text("Profile", style: TextStyle(color: Colors.white))),
//         backgroundColor: Colors.pink[600],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(
//               height: 20,
//             ),
//             // CircleAvatar(
//             //   radius: 40,
//             //   backgroundColor: Colors.blueGrey,
//             //   child: controller.userModel.value.userImg.isNotEmpty
//             //       ? CachedNetworkImage(
//             //           errorListener: (value) => Icon(Icons.error),
//             //           placeholder: (context, url) =>
//             //               CupertinoActivityIndicator(),
//             //           imageUrl: controller.userModel.value.userImg,
//             //           imageBuilder: (context, imageProvider) {
//             //             return CircleAvatar(
//             //               radius: 40,
//             //               backgroundImage: imageProvider,
//             //             );
//             //           },
//             //         )
//             //       : Icon(Icons.person),
//             // ),
//
//             Obx(() {
//               return CircleAvatar(
//                 radius: 40,
//                 backgroundColor: Colors.blueGrey,
//                 child: controller.userModel.value.userImg.isNotEmpty
//                     ? CachedNetworkImage(
//                   errorWidget: (context, url, error) => Icon(Icons.error),
//                   placeholder: (context, url) => CupertinoActivityIndicator(),
//                   imageUrl: controller.userModel.value.userImg,
//                   imageBuilder: (context, imageProvider) {
//                     return CircleAvatar(
//                       radius: 40,
//                       backgroundImage: imageProvider,
//                     );
//                   },
//                 )
//                     : Icon(Icons.person, size: 40),
//               );
//             }),
//
//             Text(
//               controller.userModel.value.username ?? "Pooja Gupta",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
//             ),
//             Text(
//               controller.userModel.value.email ?? "Poojagupta@gmail.com",
//               style: TextStyle(fontSize: 14),
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             ListTile(
//               leading: Icon(
//                 Icons.person,
//                 color: Colors.pink[600],
//               ),
//               title: Text(
//                 "Profile",
//                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
//               ),
//               trailing: Icon(
//                 Icons.arrow_forward_ios_outlined,
//                 size: 16,
//                 color: Colors.pink[600],
//               ),
//               onTap: () {
//                 Get.to(() => EditProfileScreen());
//               },
//             ),
//             Divider(
//               color: Colors.grey[300],
//               thickness: 2,
//               height: 5,
//               indent: 16,
//               endIndent: 16,
//             ),
//             ListTile(
//               leading: Icon(
//                 Icons.shopping_bag,
//                 color: Colors.pink[600],
//               ),
//               title: Text(
//                 "Orders",
//                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
//               ),
//               trailing: Icon(
//                 Icons.arrow_forward_ios_outlined,
//                 size: 16,
//                 color: Colors.pink[600],
//               ),
//               onTap: () {
//                 Get.to(() => AllOrdersScreen());
//               },
//             ),
//             Divider(
//               color: Colors.grey[300],
//               thickness: 2,
//               height: 5,
//               indent: 16,
//               endIndent: 16,
//             ),
//             ListTile(
//               leading: Icon(
//                 Icons.shopping_cart,
//                 color: Colors.pink[600],
//               ),
//               title: Text(
//                 "Carts",
//                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
//               ),
//               trailing: Icon(
//                 Icons.arrow_forward_ios_outlined,
//                 size: 16,
//                 color: Colors.pink[600],
//               ),
//               onTap: () {
//                 Get.to(() => CartScreen());
//               },
//             ),
//             Divider(
//               color: Colors.grey[300],
//               thickness: 2,
//               height: 5,
//               indent: 16,
//               endIndent: 16,
//             ),
//             ListTile(
//               leading: Icon(
//                 Icons.favorite_outline,
//                 color: Colors.pink[600],
//               ),
//               title: Text(
//                 "Wishlist",
//                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
//               ),
//               trailing: Icon(
//                 Icons.arrow_forward_ios_outlined,
//                 size: 16,
//                 color: Colors.pink[600],
//               ),
//               onTap: () {
//                 Get.to(() => FavoritesPage());
//               },
//             ),
//             Divider(
//               color: Colors.grey[300],
//               thickness: 2,
//               height: 5,
//               indent: 16,
//               endIndent: 16,
//             ),
//             ListTile(
//               leading: Icon(
//                 Icons.logout,
//                 color: Colors.pink[600],
//               ),
//               title: Text(
//                 "Logout",
//                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
//               ),
//               trailing: Icon(
//                 Icons.arrow_forward_ios_outlined,
//                 size: 16,
//                 color: Colors.pink[400],
//               ),
//               onTap: () {
//                 logout(context);
//               },
//             ),
//             Divider(
//               color: Colors.grey[300],
//               thickness: 2,
//               height: 5,
//               indent: 16,
//               endIndent: 16,
//             ),
//             ListTile(
//               leading: Icon(
//                 Icons.delete,
//                 color: Colors.pink[600],
//               ),
//               title: Text(
//                 "Delete Account",
//                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
//               ),
//               trailing: Icon(
//                 Icons.arrow_forward_ios_outlined,
//                 size: 16,
//                 color: Colors.pink[400],
//               ),
//               onTap: () {
//                 logout(context);
//               },
//             ),
//             Divider(
//               color: Colors.grey[300],
//               thickness: 2,
//               height: 5,
//               indent: 16,
//               endIndent: 16,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> logout(BuildContext context) async {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Logout"),
//           content: Text("Are you sure you want to logout?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Dismiss dialog
//               },
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () async {
//                 Navigator.of(context).pop(); // Close the dialog first
//                 try {
//                   await FirebaseAuth.instance.signOut();
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => LoginScreen()),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text("Logout failed: $e")),
//                   );
//                 }
//               },
//               child: Text("Logout", style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> deleteAccount() async {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Delete Account"),
//           content: Text(
//               "Are you sure you want to delete your account? This action cannot be undone."),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () async {
//                 try {
//                   User? user = FirebaseAuth.instance.currentUser;
//                   if (user != null) {
//                     // Delete user's profile from Firestore
//                     await FirebaseFirestore.instance
//                         .collection('users')
//                         .doc(user.uid)
//                         .delete();
//                     await user.delete();
//
//                     Get.offAllNamed('/login');
//                   }
//                 } catch (e) {
//                   print(e);
//                   Get.snackbar("Error", "Failed to delete account",
//                       backgroundColor: Colors.red, colorText: Colors.white);
//                 }
//               },
//               child: Text("Delete", style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/user_controller.dart';
import '../../login/login.dart';
import '../cart/cart_screen.dart';
import '../order/all_order_screen.dart';
import '../order/editprofile_screen.dart';
import '../favorurite/favorite_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SignUpController controller = Get.put(SignUpController());

  @override
  void initState() {
    super.initState();
    controller.fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text("Profile", style: TextStyle(color: Colors.white))),
        backgroundColor: Colors.pink[400],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Obx(() {
              return CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blueGrey,
                backgroundImage: controller.userModel.value.userImg.isNotEmpty
                    ? CachedNetworkImageProvider(
                        controller.userModel.value.userImg)
                    : null,
                child: controller.userModel.value.userImg.isEmpty
                    ? Icon(Icons.person, size: 40)
                    : null,
              );
            }),
            SizedBox(height: 10),
            Obx(() => Text(
                  controller.userModel.value.username ?? "User Name",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                )),
            Obx(() => Text(
                  controller.userModel.value.email ?? "user@example.com",
                  style: TextStyle(fontSize: 14),
                )),
            SizedBox(height: 5),
            _buildProfileOption(Icons.person, "Profile",
                () => Get.to(() => EditProfileScreen())),
            _buildProfileOption(Icons.shopping_bag, "Orders",
                () => Get.to(() => AllOrdersScreen())),
            _buildProfileOption(
                Icons.shopping_cart, "Carts", () => Get.to(() => CartScreen())),
            _buildProfileOption(Icons.favorite_outline, "Wishlist",
                () => Get.to(() => FavoritesPage())),
            _buildProfileOption(Icons.logout, "Logout", () => logout(context)),
            _buildProfileOption(
                Icons.delete, "Delete Account", () => deleteAccount(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.pink[600]),
          title: Text(title,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          trailing: Icon(Icons.arrow_forward_ios_outlined,
              size: 16, color: Colors.pink[600]),
          onTap: onTap,
        ),
        Divider(
            color: Colors.grey[300],
            thickness: 2,
            height: 5,
            indent: 16,
            endIndent: 16),
      ],
    );
  }

  Future<void> logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Get.offAll(() => LoginScreen());
              },
              child: Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteAccount(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Account"),
          content: Text(
              "Are you sure you want to delete your account? This action cannot be undone."),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            TextButton(
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .delete();
                  await user.delete();
                  Get.offAll(() => LoginScreen());
                }
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
