// //
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import '../../../controller/products_price_controller.dart';
// // import '../../../model/order_model.dart';
// //
// //
// //
// // class AllOrdersScreen extends StatefulWidget {
// //   const AllOrdersScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   State<AllOrdersScreen> createState() => _AllOrdersScreenState();
// // }
// //
// // class _AllOrdersScreenState extends State<AllOrdersScreen> {
// //   final User? user = FirebaseAuth.instance.currentUser;
// //   final ProductPriceController productPriceController =
// //   Get.put(ProductPriceController());
// //
// //   Future<void> _confirmDeleteDialog(
// //       String orderId, BuildContext context) async {
// //     return showDialog<void>(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: Text('Confirm Cancel'),
// //           content: SingleChildScrollView(
// //             child: ListBody(
// //               children: <Widget>[
// //                 Text('Are you sure you want to cancel this order?'),
// //               ],
// //             ),
// //           ),
// //           actions: <Widget>[
// //             TextButton(
// //               onPressed: () async {
// //                 await FirebaseFirestore.instance
// //                     .collection('orders')
// //                     .doc(user?.uid)
// //                     .collection('confirmOrders')
// //                     .doc(orderId)
// //                     .delete();
// //                 Navigator.of(context).pop();
// //               },
// //               child: Text('Yes'),
// //             ),
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               },
// //               child: Text('No'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //
// //         elevation: 1,
// //         backgroundColor: Colors.pink[400],
// //         title: Text(
// //           'All Orders',
// //           style: TextStyle(color: Colors.white),
// //         ),
// //       ),
// //       body: StreamBuilder(
// //         stream: FirebaseFirestore.instance
// //             .collection('orders')
// //             .doc(user!.uid)
// //             .collection('confirmOrders')
// //             .snapshots(),
// //         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
// //           if (snapshot.hasError) {
// //             return Center(
// //               child: Text("Error"),
// //             );
// //           }
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return Container(
// //               height: Get.height / 5,
// //               child: Center(
// //                 child: CupertinoActivityIndicator(),
// //               ),
// //             );
// //           }
// //
// //           if (snapshot.data!.docs.isEmpty) {
// //             return Center(
// //               child: Text("No products found!"),
// //             );
// //           }
// //
// //           if (snapshot.data != null) {
// //             return Container(
// //               child: ListView.builder(
// //                 itemCount: snapshot.data!.docs.length,
// //                 shrinkWrap: true,
// //                 physics: BouncingScrollPhysics(),
// //                 itemBuilder: (context, index) {
// //                   final productData = snapshot.data!.docs[index];
// //                   OrderModel orderModel = OrderModel(
// //                     productId: productData['productId'],
// //                     productName: productData['productName'],
// //                     fullPrice: productData['fullPrice'],
// //                     productImages: productData['productImages'],
// //
// //                     productDescription: productData['productDescription'],
// //                     createdAt: productData['createdAt'],
// //                     updatedAt: productData['updatedAt'],
// //                     productQuantity: productData['productQuantity'],
// //                     productTotalPrice: double.parse(
// //                         productData['productTotalPrice'].toString()),
// //                     customerId: productData['customerId'],
// //                     status: productData['status'],
// //                     customerName: productData['customerName'],
// //                     customerPhone: productData['customerPhone'],
// //                     customerAddress: productData['customerAddress'],
// //                     customerEmail: productData['customerEmail'],
// //                   );
// //
// //                   //calculate price
// //                   productPriceController.fetchProductPrice();
// //                   return Card(
// //                     elevation: 5,
// //                     color: Colors.grey[100],
// //                     child: ListTile(
// //                       leading: Container(
// //                           width: 50,
// //                           height: 80,
// //                           decoration: BoxDecoration(
// //                               borderRadius: BorderRadius.circular(10)
// //                           ),
// //                           child: Image.network(orderModel.productImages[0]
// //                           )),
// //                       title: Text(orderModel.productName),
// //                       subtitle: Row(
// //                         mainAxisAlignment: MainAxisAlignment.start,
// //                         children: [
// //                           Text(orderModel.productTotalPrice.toString()),
// //                           SizedBox(
// //                             width: 10.0,
// //                           ),
// //                           orderModel.status != true
// //                               ? Text(
// //                             "Pending..",
// //                             style: TextStyle(color: Colors.green),
// //                           )
// //                               : Text(
// //                             "Delivered",
// //                             style: TextStyle(color: Colors.red[400]),
// //                           ),
// //                           TextButton(
// //                             onPressed: () async {
// //                               await _confirmDeleteDialog(
// //                                   orderModel.productId, context);
// //                             },
// //                             child: Text("Cancel Order"),
// //                           )
// //                         ],
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               ),
// //             );
// //           }
// //
// //           return Container();
// //         },
// //       ),
// //     );
// //   }
// // }
//
//
//  // Chanj code
//
//


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/products_price_controller.dart';
import '../../../model/order_model.dart';
import 'order_details.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({Key? key}) : super(key: key);

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
  Get.put(ProductPriceController());

  Future<void> _confirmDeleteDialog(String orderId, BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('Cancel Order',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          content: Text('Are you sure you want to cancel this order?',
              style: TextStyle(fontSize: 16)),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('orders')
                    .doc(user?.uid)
                    .collection('confirmOrders')
                    .doc(orderId)
                    .delete();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Order Cancelled Successfully!"),
                    backgroundColor: Colors.red[300],
                  ),
                );
              },
              child: Text('Yes', style: TextStyle(color: Colors.red[300])),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.pink[400],
        title: Text('All Orders',
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600)),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(user!.uid)
            .collection('confirmOrders')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text("Error fetching orders",
                    style: TextStyle(fontSize: 16, color: Colors.red[300])));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CupertinoActivityIndicator(radius: 18));
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text("No orders found!",
                    style: TextStyle(fontSize: 18, color: Colors.grey)));
          }

          return Padding(
            padding: EdgeInsets.all(12),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final productData = snapshot.data!.docs[index];
                OrderModel orderModel = OrderModel.fromMap(
                    productData.data() as Map<String, dynamic>);

                productPriceController.fetchProductPrice();

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsScreen(order: orderModel),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              orderModel.productImages[0],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  orderModel.productName,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "₹${orderModel.productTotalPrice.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.pink[400]),
                                ),
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: orderModel.status != true
                                            ? Colors.orange[100]
                                            : Colors.green[100],
                                        borderRadius:
                                        BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        orderModel.status != true
                                            ? "Pending.."
                                            : "Delivered",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: orderModel.status != true
                                              ? Colors.orange[800]
                                              : Colors.green[800],
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await _confirmDeleteDialog(
                                            orderModel.productId, context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red[300],
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(8)),
                                      ),
                                      child: Text("Cancel",
                                          style:
                                          TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}