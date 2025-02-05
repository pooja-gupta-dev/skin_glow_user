// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class DeliveredOrdersScreen extends StatelessWidget {
//   final User? user = FirebaseAuth.instance.currentUser;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         elevation: 3,
//         backgroundColor: Colors.green[400],
//         title: Text(
//           'Delivered Orders',
//           style: TextStyle(
//               color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
//         ),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('orders')
//             .doc(user!.uid)
//             .collection('confirmOrders')
//             .where('status', isEqualTo: true)  // ✅ Filter for Delivered Orders
//             .snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Center(
//                 child: Text("Error fetching delivered orders",
//                     style: TextStyle(fontSize: 16, color: Colors.red)));
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CupertinoActivityIndicator(radius: 18));
//           }
//           if (snapshot.data!.docs.isEmpty) {
//             return Center(
//                 child: Text("No delivered orders found!",
//                     style: TextStyle(fontSize: 18, color: Colors.grey)));
//           }
//
//           return Padding(
//             padding: EdgeInsets.all(12),
//             child: ListView.builder(
//               itemCount: snapshot.data!.docs.length,
//               shrinkWrap: true,
//               physics: BouncingScrollPhysics(),
//               itemBuilder: (context, index) {
//                 final productData = snapshot.data!.docs[index];
//
//                 return Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//                   elevation: 4,
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Row(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: Image.network(
//                             productData['productImages'][0],
//                             width: 50,
//                             height: 50,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 productData['productName'],
//                                 style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               SizedBox(height: 4),
//                               Text(
//                                 "₹${productData['productTotalPrice'].toStringAsFixed(2)}",
//                                 style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.green[600]),
//                               ),
//                               SizedBox(height: 6),
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 4, horizontal: 12),
//                                 decoration: BoxDecoration(
//                                   color: Colors.green[100],
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: Text(
//                                   "Delivered",
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.green[800],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
