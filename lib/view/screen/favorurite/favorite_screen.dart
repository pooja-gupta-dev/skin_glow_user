// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:get/get.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:user_app/view/screen/bottomNavigationn/bottom_navigtion.dart';
// // import '../../../model/product_model.dart';
// // import '../../../widget/custom_button.dart';
// //
// // class FavoritesPage extends StatefulWidget {
// //   @override
// //   _FavoritesPageState createState() => _FavoritesPageState();
// // }
// //
// // class _FavoritesPageState extends State<FavoritesPage> {
// //   late User? user;
// //   List<ProductModel> favoriteProducts = [];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     user = FirebaseAuth.instance.currentUser;
// //     fetchFavoriteProducts();
// //   }
// //
// //   Future<void> fetchFavoriteProducts() async {
// //     if (user == null) return;
// //
// //     final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
// //         .collection('favorites')
// //         .doc(user!.uid)
// //         .collection('favoriteProducts')
// //         .get();
// //
// //     final List<ProductModel> products = [];
// //     querySnapshot.docs.forEach((doc) {
// //       final product = ProductModel.fromJson(doc.data() as Map<String, dynamic>);
// //       products.add(product);
// //     });
// //
// //     setState(() {
// //       favoriteProducts = products;
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         iconTheme: IconThemeData(color: Colors.white),
// //         title: Text("Favorites",
// //             style: const TextStyle(color: Colors.white)),
// //         backgroundColor: Colors.pink[600],
// //       ),
// //       body: favoriteProducts.isEmpty
// //           ? Center(
// //         child: Column(
// //           children: [
// //             SizedBox(height: 30),
// //             Image.asset(
// //               'assets/images/empty_favroite.jpg',
// //               height: 300,
// //               width: 300,
// //               fit: BoxFit.cover,
// //             ),
// //             const SizedBox(height: 20),
// //             Text(
// //               'Your heart is empty',
// //               style:
// //               GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             Text(
// //               'Start fall in love with some good',
// //               style:
// //               GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w300),
// //             ),
// //             Text(
// //               'goods',
// //               style:
// //               GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w300),
// //             ),
// //             SizedBox(
// //               height: 30,
// //             ),
// //             EelvetButton(
// //               onPressed: () {
// //                 Get.offAll(() => BottomNavExample());
// //               },
// //               buttonText: 'Start Shopping',
// //             ),
// //           ],
// //         ),
// //       )
// //           : GridView.builder(
// //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //           crossAxisCount: 2,
// //           crossAxisSpacing: 10.0,
// //           mainAxisSpacing: 10.0,
// //           childAspectRatio: 0.7, // Adjust aspect ratio for grid items
// //         ),
// //         itemCount: favoriteProducts.length,
// //         itemBuilder: (context, index) {
// //           final product = favoriteProducts[index];
// //           return Container(
// //             decoration: BoxDecoration(
// //               color: Colors.grey[100],
// //               borderRadius: BorderRadius.circular(10),
// //             ),
// //             child: Card(
// //               elevation: 5,
// //               child: Column(
// //                 children: [
// //                   Stack(
// //                     children: [
// //                       ClipRRect(
// //                         borderRadius: BorderRadius.circular(10),
// //                         child: CachedNetworkImage(
// //                           imageUrl: product.productImages[0],
// //                           height: 150,
// //                           width: double.infinity,
// //                           fit: BoxFit.cover,
// //                         ),
// //                       ),
// //                       if (user != null)
// //                         Positioned(
// //                           top: 8,
// //                           right: 8,
// //                           child: GestureDetector(
// //                             onTap: () {
// //                               showDialog(
// //                                 context: context,
// //                                 builder: (BuildContext context) {
// //                                   return AlertDialog(
// //                                     title: Text("Confirm"),
// //                                     content: Text("Delete this item?"),
// //                                     actions: [
// //                                       TextButton(
// //                                         onPressed: () async {
// //                                           Navigator.of(context).pop();
// //                                           await removeFromFavorites(product);
// //                                         },
// //                                         child: Text("Delete"),
// //                                       ),
// //                                       TextButton(
// //                                         onPressed: () {
// //                                           Navigator.of(context).pop();
// //                                         },
// //                                         child: Text("Cancel"),
// //                                       ),
// //                                     ],
// //                                   );
// //                                 },
// //                               );
// //                             },
// //                             child: CircleAvatar(
// //                               radius: 14.0,
// //                               backgroundColor: Colors.red,
// //                               child: Icon(Icons.delete, color: Colors.white),
// //                             ),
// //                           ),
// //                         ),
// //                     ],
// //                   ),
// //                   SizedBox(height: 8),
// //                   Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
// //                     child: Text(
// //                       product.productName,
// //                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //                       maxLines: 1,
// //                       overflow: TextOverflow.ellipsis,
// //                     ),
// //                   ),
// //                   SizedBox(height: 4),
// //                   Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
// //                     child: Text(
// //                       product.fullPrice,
// //                       style: TextStyle(fontSize: 14, color: Colors.green),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// //
// //   Future<void> removeFromFavorites(ProductModel product) async {
// //     if (user == null) return;
// //
// //     await FirebaseFirestore.instance
// //         .collection('favorites')
// //         .doc(user!.uid)
// //         .collection('favoriteProducts')
// //         .doc(product.productId)
// //         .delete();
// //     fetchFavoriteProducts();
// //   }
// //
// //
// //
// //
// //
// // }
//

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_app/view/screen/bottomNavigationn/bottom_navigtion.dart';
import '../../../model/product_model.dart';
import '../../../widget/custom_button.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late User? user;
  List<ProductModel> favoriteProducts = [];
  bool isInCart = false;
  int cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    fetchFavoriteProducts();
    fetchCartItemCount();
  }

  Future<void> fetchFavoriteProducts() async {
    if (user == null) return;

    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('favorites')
        .doc(user!.uid)
        .collection('favoriteProducts')
        .get();

    final List<ProductModel> products = [];
    querySnapshot.docs.forEach((doc) {
      final product = ProductModel.fromJson(doc.data() as Map<String, dynamic>);
      products.add(product);
    });

    setState(() {
      favoriteProducts = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Favorites", style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink[400],
      ),
      body: favoriteProducts.isEmpty
          ? SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Let it take minimum height
            children: [
              SizedBox(height: 30),
              Image.asset(
                'assets/images/empty_favroite.jpg',
                height: 300,
                width: 300,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              Text(
                'Your heart is empty',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Start falling in love with some good',
                style: GoogleFonts.poppins(
                    fontSize: 15, fontWeight: FontWeight.w300),
              ),
              Text(
                'goods',
                style: GoogleFonts.poppins(
                    fontSize: 15, fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: 30,
              ),
              EelvetButton(
                onPressed: () {
                  Get.offAll(() => BottomNavExample());
                },
                buttonText: 'Start Shopping',
              ),
            ],
          ),
        ),
      )
          : GridView.builder(
        padding: EdgeInsets.all(8), // Added padding to avoid clutter
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0, // Add spacing between items
          mainAxisSpacing: 10.0, // Add spacing between items vertically
          childAspectRatio: 0.6, // Adjusted aspect ratio to prevent overflow
        ),
        itemCount: favoriteProducts.length,
        itemBuilder: (context, index) {
          final product = favoriteProducts[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Card(
              elevation: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: product.productImages[0],
                      height: 120, // Fixed image height
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      product.productName,
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      product.fullPrice,
                      style:
                      TextStyle(fontSize: 14, color: Colors.green),
                    ),
                  ),
                  Spacer(), // Push buttons to the bottom of the card
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () async {
                          await removeFromFavorites(product);
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                      ),
                      isInCart
                          ? IconButton(
                        onPressed: () async {
                          await removeFromCart(product);
                        },
                        icon: Icon(
                          Icons.remove_shopping_cart,
                          color: Colors.orange,
                        ),
                      )
                          : IconButton(
                        onPressed: () async {
                          await addToCart(product);
                        },
                        icon: Icon(
                          Icons.add_shopping_cart,
                          color: Colors.blue[200],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> removeFromFavorites(ProductModel product) async {
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('favorites')
        .doc(user!.uid)
        .collection('favoriteProducts')
        .doc(product.productId)
        .delete();
    fetchFavoriteProducts();
  }

  Future<void> addToCart(ProductModel product) async {
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(user!.uid)
          .collection('cartOrders')
          .doc(product.productId)
          .set(
        {
          'productQuantity': 1,
          'productTotalPrice': double.parse(product.fullPrice),
          ...product.toMap(),
        },
      );

      setState(() {
        isInCart = true;
      });
      Get.snackbar("Successfully Added", "Added to cart",
          backgroundColor: Colors.white,
          padding: EdgeInsets.all(10),
          colorText: Colors.green);
    } catch (e) {
      print("Error adding to cart: $e");
    }
  }

  Future<void> removeFromCart(ProductModel product) async {
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(user!.uid)
          .collection('cartOrders')
          .doc(product.productId)
          .delete();

      setState(() {
        isInCart = false;
      });
      Get.snackbar("Successfully Removed", "Removed from cart",
          backgroundColor: Colors.white,
          padding: EdgeInsets.all(10),
          colorText: Colors.red);
    } catch (e) {
      print("Error removing from cart: $e");
    }
  }

  Future<void> fetchCartItemCount() async {
    if (user == null) return;

    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user!.uid)
          .collection('cartOrders')
          .get();

      setState(() {
        cartItemCount = querySnapshot.size;
      });
    } catch (e) {
      print("Error fetching cart item count: $e");
    }
  }
}
