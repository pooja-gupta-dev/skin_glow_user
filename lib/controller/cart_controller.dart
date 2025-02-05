import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../model/cart_model.dart';

class CartController extends GetxController {
  var isDataAvailable = false.obs;
  var cartItems = <CartModel>[].obs;
  var totalPrice = 0.0.obs;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    super.onInit();
    _loadCartItems();
  }

  // Load cart items from Firestore
  void _loadCartItems() {
    FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        isDataAvailable.value = false;
      } else {
        isDataAvailable.value = true;
        cartItems.clear();
        snapshot.docs.forEach((doc) {
          cartItems.add(CartModel(
            productId: doc['productId'],
            productName: doc['productName'],
            fullPrice: doc['fullPrice'],
            productImages: List<String>.from(doc['productImages']),
            productDescription: doc['productDescription'],
            createdAt: doc['createdAt'],
            updatedAt: doc['updatedAt'],
            productQuantity: doc['productQuantity'], // Ensure productQuantity is correctly fetched
            productTotalPrice: double.parse(doc['productTotalPrice'].toString()),
          ));
        });
      }
      _calculateTotalPrice();
    });
  }

  // Calculate total price of cart items
  void _calculateTotalPrice() {
    totalPrice.value = 0.0;
    for (var item in cartItems) {
      totalPrice.value += item.productTotalPrice;
    }
  }

  // Update product quantity (increase or decrease)
  void updateProductQuantity(CartModel cartModel, bool increase) {
    int newQuantity = increase ? cartModel.productQuantity + 1 : cartModel.productQuantity - 1;
    if (newQuantity > 0) {
      FirebaseFirestore.instance
          .collection('cart')
          .doc(user!.uid)
          .collection('cartOrders')
          .doc(cartModel.productId)
          .update({
        'productQuantity': newQuantity,
        'productTotalPrice': double.parse(cartModel.fullPrice) * newQuantity,
      });
      cartModel.productQuantity = newQuantity;
      cartModel.productTotalPrice = double.parse(cartModel.fullPrice) * newQuantity;
      _calculateTotalPrice();
    }
  }

  // Delete product from cart
  void deleteProduct(CartModel cartModel) async {
    await FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders')
        .doc(cartModel.productId)
        .delete();
    _loadCartItems(); // Re-fetch items after deletion
  }
}
