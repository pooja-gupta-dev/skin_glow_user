import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/order_model.dart';
import '../model/product_model.dart';
import 'generate_order_id.dart';

void SingleOrder({
  required BuildContext context,
  required String customerName,
  required String customerPhone,
  required String customerAddress,
  required String customerEmail,
  required int quantity,
  required ProductModel productModel,
}) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    try {
      var orderModel = OrderModel(
        productId: productModel.productId,
        productName: productModel.productName,
        fullPrice: productModel.fullPrice,
        productImages: productModel.productImages,
        productDescription: productModel.productDescription,
        createdAt: productModel.createdAt,
        updatedAt: productModel.updatedAt,
        productQuantity: quantity,
        productTotalPrice: double.parse(productModel.fullPrice),
        customerId: user.uid,
        status: false,
        customerName: customerName,
        customerPhone: customerPhone,
        customerAddress: customerAddress,
        customerEmail: customerEmail,
      );
      String orderId = generateOrderId();

      // Upload order details
      await FirebaseFirestore.instance.collection('orders').doc(user.uid).set({
        'uId': user.uid,
        'customerName': customerName,
        'customerPhone': customerPhone,
        'customerAddress': customerAddress,
        'customerEmail': customerEmail,
        'orderStatus': false,
        'createdAt': DateTime.now()
      });


      // Upload order model
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(user.uid)
          .collection('confirmOrders')
          .doc(orderId)
          .set(orderModel.toMap());

    } catch (e) {
      print("Error: $e");
    }
  }
}
