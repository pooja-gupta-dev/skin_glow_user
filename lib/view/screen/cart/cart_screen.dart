import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controller/cart_controller.dart';
import '../../../widget/custom_button.dart';
import '../bottomNavigationn/bottom_navigtion.dart';
import '../order/cart_products_order_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Cart Screen",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.pink[400],
      ),
      body: Obx(
        () {
          if (!cartController.isDataAvailable.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/empty_cart.png',
                    height: 170,
                    width: 400,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    'Your cart is empty',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  EelvetButton(
                    onPressed: () {
                      Get.offAll(() => BottomNavExample());

                    },
                    buttonText: 'Start Shopping',
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        itemCount: cartController.cartItems.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final cartModel = cartController.cartItems[index];
                          return Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.grey.shade300, width: 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 1,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                          cartModel.productImages[0],
                                        ),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 3,
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cartModel.productName,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          cartModel.productTotalPrice
                                              .toString(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.brown,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          cartController.updateProductQuantity(
                                              cartModel, false);
                                        },
                                        icon: Icon(
                                            Icons
                                                .remove_circle_outline_outlined,
                                            color: Colors.brown),
                                      ),
                                      Text(
                                        "${cartModel.productQuantity}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          cartController.updateProductQuantity(
                                              cartModel, true);
                                        },
                                        icon: Icon(
                                          Icons.add_circle_outline,
                                          color: Colors.brown,
                                        ),
                                      ),
                                    ],
                                  ),
                                  CircleAvatar(
                                    child: IconButton(
                                      onPressed: () {
                                        cartController.deleteProduct(cartModel);
                                      },
                                      icon: Icon(Icons.delete_outline,
                                          color: Colors.red[400]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Item Amount',
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                          Text(
                            "${cartController.totalPrice.value.toStringAsFixed(1)} ",
                            style: GoogleFonts.poppins(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Discount',
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                          Text(
                            '\$0.00',
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: GoogleFonts.poppins(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "${cartController.totalPrice.value.toStringAsFixed(1)} ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 2,),
                      SizedBox(
                        width: double.infinity,
                        child:   EelvetButton(

                          onPressed: () {
                             Get.to(() => UserProductOrderScreen());
                          },
                          buttonText: ' Shopping',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
