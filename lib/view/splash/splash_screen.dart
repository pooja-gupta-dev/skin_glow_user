// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:user_app/view/login/login.dart';
// import '../screen/bottomNavigationn/bottom_navigtion.dart';
//
//
// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//
//   var user = FirebaseAuth.instance.currentUser?.uid;
//   @override
//   void initState() {
//     super.initState();
//     Timer(const Duration(seconds: 3), () {
//       if (user != null) {
//
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavExample(),));
//       }
//       else {
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.pinkAccent,
//               Colors.white,
//             ],
//
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               const CircleAvatar(
//                 radius: 100,
//                 backgroundImage: AssetImage('assets/images/ss.jpg'),
//               ),
//               CircularProgressIndicator(),
//               const SizedBox(height: 50),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_app/view/login/login.dart';
import '../screen/bottomNavigationn/bottom_navigtion.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var user = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavExample()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.pink[600],
      //   title: Text("Skin Glow",style: TextStyle(color: Colors.white),),
      // ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/ss.jpg'),
            fit: BoxFit.cover, // Ensures the image covers the entire screen
          ),
          gradient: const LinearGradient(
            colors: [Colors.pink, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.7], // Blends the gradient over the image
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 300), // Adjust to align content as needed
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              "Loading...",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
