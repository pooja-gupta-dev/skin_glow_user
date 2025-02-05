import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/order_model.dart';
import 'generate_order_id.dart';


void placeOrder({
  required BuildContext context,
  required String customerName,
  required String customerPhone,
  required String customerAddress,
  required String customerEmail,

}) async {
  final user = FirebaseAuth.instance.currentUser;
  // EasyLoading.show(status: "Please Wait..");
  if (user != null) {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('cartOrders')
          .get();

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (var doc in documents) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;

        String orderId = generateOrderId();

        OrderModel orderModel = OrderModel(
          productId: data['productId'],
          productName: data['productName'],
          fullPrice: data['fullPrice'],
          productImages: data['productImages'],
          productDescription: data['productDescription'],
          createdAt: DateTime.now(),
          updatedAt: data['updatedAt'],
          productQuantity: data['productQuantity'],
          productTotalPrice: double.parse(data['productTotalPrice'].toString()),
          customerId: user.uid,
          status: false,
          customerName: customerName,
          customerPhone: customerPhone,
          customerAddress: customerAddress,
          customerEmail: customerEmail,

        );

        for (var x = 0; x < documents.length; x++) {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .set(
            {
              'uId': user.uid,
              'customerName': customerName,
              'customerPhone': customerPhone,
              'customerAddress': customerAddress,
              'customerEmail': customerEmail,
              'orderStatus': false,
              'createdAt': DateTime.now()
            },
          );

          //upload orders
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .collection('confirmOrders')
              .doc(orderId)
              .set(orderModel.toMap());

          //delete cart products
          await FirebaseFirestore.instance
              .collection('cart')
              .doc(user.uid)
              .collection('cartOrders')
              .doc(orderModel.productId.toString())
              .delete()
              .then((value) {
            print('Delete cart Products $orderModel.productId.toString()');
          });
        }
      }

      print("Order Confirmed");
      // Get.snackbar(
      //   "Order Confirmed",
      //   "Thank you for your order!",
      //   backgroundColor: AppConstant.appMainColor,
      //   colorText: Colors.white,
      //   duration: Duration(seconds: 3),
      // );


      // Get.offAll(() => MainScreen());
    } catch (e) {
      print("error $e");
    }
  }
}
