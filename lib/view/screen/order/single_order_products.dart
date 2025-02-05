import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:user_app/view/screen/bottomNavigationn/bottom_navigtion.dart';
import '../../../controller/order_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../model/product_model.dart';
import '../../../widget/cutom_textfield.dart';


class SingleProductsOrders extends StatefulWidget {
  SingleProductsOrders({Key? key, required this.productModel})
      : super(key: key);

  final ProductModel productModel;

  @override
  State<SingleProductsOrders> createState() => _SingleProductsOrdersState();
}

class _SingleProductsOrdersState extends State<SingleProductsOrders> {
  late String userId;
  bool _isEditing = false; // Controls whether the fields are editable or not
  bool _isDataSaved = false;

  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var addressController = TextEditingController();
  late Razorpay _razorpay;
  bool _isProcessingPayment = false;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _loadUserData(); // Load data from Firestore
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Get.snackbar("Orders Confirmed", "Thank you for your orders!",
        backgroundColor: Colors.black,
        colorText: Colors.white,
        duration: Duration(seconds: 3));
    Get.offAll(() => BottomNavExample());
    SingleOrder(
      context: context,
      customerName: nameController.text,
      customerPhone: phoneController.text,
      customerAddress: addressController.text,
      customerEmail: emailController.text,
      quantity: 1,
      productModel: widget.productModel,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      _isProcessingPayment = false;
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
  }

  void _openCheckout(double amount) {
    var options = {
      'key': 'rzp_test_H2ikvp5dFN1Rh0',
      'amount': (amount * 100).toInt(),
      'name': 'Skin Glow',
      'description': 'Payment for products',
      'prefill': {
        'contact': phoneController.text,
        'email': emailController.text,
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
    }
  }

  Future<void> _loadUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('orderusers')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        nameController.text = data['name'] ?? '';
        phoneController.text = data['phone'] ?? '';
        emailController.text = data['email'] ?? '';
        addressController.text = data['address'] ?? '';
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  Future<void> _saveData() async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        addressController.text.isEmpty) {
      Get.snackbar("Please Fill all Fields", "Please fill all fields",
          backgroundColor: Colors.black,
          colorText: Colors.white,
          duration: Duration(seconds: 3));
    } else {
      setState(() {
        _isEditing = false; // Disable the fields after saving
        _isDataSaved = true;
      });
      // Save to Firebase
      try {
        await FirebaseFirestore.instance
            .collection('orderusers')
            .doc(userId)
            .set({
          'name': nameController.text,
          'phone': phoneController.text,
          'email': emailController.text,
          'address': addressController.text,
        }, SetOptions(merge: true));
      } catch (e) {
        Get.snackbar("Error", "There was an error saving your data.");
      }
    }
  }

  void _editData() {
    setState(() {
      _isEditing = true; // Enable the fields for editing
    });
  }

  void _savedatapayment() {
    if (_isDataSaved) {
      double price =  double.parse(widget.productModel.fullPrice);
      _openCheckout(price);
    } else {
      Get.snackbar("Please Save Data First",
          "Please save your details before proceeding.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.pink[400],

        title: Text("Order",
          style: TextStyle(color: Colors.white),
        ),

        // leading: Padding(
        //   padding: const EdgeInsets.only(left: 13),
        //   child: CircleAvatar(
        //     backgroundColor: Colors.white,
        //     radius: 20,
        //     child: IconButton(
        //       icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 17),
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //     ),
        //   ),
        // ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productModel.productName,
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 180,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: widget.productModel.productImages[0],
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          placeholder: (context, url) =>
                              CupertinoActivityIndicator(),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Price: ${ widget.productModel.fullPrice}",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              CustomTextField(
                hintText: 'Please enter Name',
                icon: Icons.person,
                label: "Name",
                inputType: TextInputType.text,
                controller: nameController,
                readOnly: !_isEditing,
              ),
              CustomTextField(
                hintText: 'Please enter Phone',
                icon: Icons.phone,
                label: "Phone",
                inputType: TextInputType.number,
                controller: phoneController,
                readOnly: !_isEditing, // Set readOnly based on _isEditing
              ),
              CustomTextField(
                hintText: 'Please enter Email',
                icon: Icons.email,
                label: "Email",
                inputType: TextInputType.emailAddress,
                controller: emailController,
                readOnly: !_isEditing, // Set readOnly based on _isEditing
              ),
              CustomTextField(
                hintText: 'Please enter Address',
                icon: Icons.home,
                label: "Address",
                inputType: TextInputType.text,
                controller: addressController,
                readOnly: !_isEditing, // Set readOnly based on _isEditing
              ),
              Padding(
                padding: const EdgeInsets.only(left: 290, bottom: 20),
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    onPressed: _isEditing ? _saveData : _editData,
                    icon: Icon(
                      _isEditing ? Icons.save : Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: _isProcessingPayment ? null : _savedatapayment,
                child: _isProcessingPayment
                    ? CircularProgressIndicator()
                    : Text(
                  "Proceed to Payment",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
