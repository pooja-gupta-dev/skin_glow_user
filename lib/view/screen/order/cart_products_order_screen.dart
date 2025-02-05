
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:user_app/view/screen/bottomNavigationn/bottom_navigtion.dart';
import '../../../controller/cart_products_order_controller.dart';
import '../../../controller/products_price_controller.dart';
import '../../../model/cart_model.dart';
import '../../../widget/cutom_textfield.dart';


class UserProductOrderScreen extends StatefulWidget {
  const UserProductOrderScreen({Key? key}) : super(key: key);

  @override
  State<UserProductOrderScreen> createState() => _UserProductOrderScreenState();
}

class _UserProductOrderScreenState extends State<UserProductOrderScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
  Get.put(ProductPriceController());
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();
  var emailController = TextEditingController();
  late Razorpay _razorpay;

  late String userId;
  bool _isEditing = false;
  bool _isDataSaved = false;

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

  void _editData() {
    setState(() {
      _isEditing = true; // Enable the fields for editing
    });
  }

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
    _loadUserData();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment Successful");
    Get.snackbar(
      "Orders Confirmed",
      "Thank you for your orders!",
      backgroundColor: Colors.black,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );

    Get.offAll(() => BottomNavExample());
    // EasyLoading.dismiss();
    placeOrder(
      context: context,
      customerName: nameController.text,
      customerPhone: phoneController.text,
      customerAddress: addressController.text,
      customerEmail: emailController.text,
    );
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

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Failed: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
  }

  void _openCheckout(double amount) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.pink[600],
        title: Text(
          'Order ',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.uid)
            .collection('cartOrders')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: Get.height / 5,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No products found!"),
            );
          }

          if (snapshot.data != null) {
            return Container(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final productData = snapshot.data!.docs[index];
                  CartModel cartModel = CartModel(
                    productId: productData['productId'],
                    productName: productData['productName'],
                    fullPrice: productData['fullPrice'],
                    productImages: productData['productImages'],

                    productDescription: productData['productDescription'],
                    createdAt: productData['createdAt'],
                    updatedAt: productData['updatedAt'],
                    productQuantity: productData['productQuantity'],
                    productTotalPrice: double.parse(
                        productData['productTotalPrice'].toString()),
                  );

                  productPriceController.fetchProductPrice();
                  return Container(
                    key: ObjectKey(cartModel.productId),
                    child: GestureDetector(
                      onTap: () async {
                        _showDeleteConfirmationDialog(
                            context, cartModel.productId);
                      },
                      child: Card(
                        elevation: 5,
                        color: Colors.grey[100],
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage:
                            NetworkImage(cartModel.productImages[0]),
                          ),
                          title: Text(cartModel.productName),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(cartModel.productTotalPrice.toString()),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              _showDeleteConfirmationDialog(
                                  context, cartModel.productId);
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Container();
        },
      ),
      bottomNavigationBar: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
                  () => Text(
                " Total R - ${productPriceController.totalPrice.value
                    .toStringAsFixed(1)} ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                child: Container(
                  width: Get.width / 2.0,
                  height: Get.height / 18,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton(
                    child: Text(
                      "Confirm Order",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      showCustomBottomSheet();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this item?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('cart')
                    .doc(user!.uid)
                    .collection('cartOrders')
                    .doc(productId)
                    .delete();
                Navigator.of(context).pop();
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void showCustomBottomSheet() {
    Get.bottomSheet(
      Center(
        child: Container(
          height: Get.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.0),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 37,
                  ),
                  CustomTextField(
                    hintText: 'Please enter Name',
                    icon: Icons.person,
                    label: "Name",
                    inputType: TextInputType.text,
                    controller: nameController,
                    readOnly: !_isEditing, // Set readOnly based on _isEditing
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
                      backgroundColor: Colors.pink,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    ),
                    onPressed: () {
                      _savedatapayment(context);
                    },
                    child: Text(
                      "Payment now",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      elevation: 6,
    );
  }

  void _savedatapayment(BuildContext context) async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        emailController.text.isEmpty) {
      Get.snackbar("please fill", "Please fill all fields!");
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        },
      );

      try {
        _openCheckout(productPriceController.totalPrice.value);
      } catch (e) {
        print("Payment Error: $e");
        Navigator.pop(context);
      }
    }
  }
}
