import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/view/screen/favorurite/favorite_screen.dart';
import '../../../model/product_model.dart';
import '../cart/cart_screen.dart';
import '../order/single_order_products.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late User? user;
  bool isInCart = false;
  bool isFavorite = false;
  int cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    checkProductExistence();
    checkFavoriteExistence();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.productName,
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink[400],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),

        actions: [
          CircleAvatar(
            backgroundColor: Colors.white, // Light White BG
            child: IconButton(
              icon: Icon(Icons.favorite_border, color: Colors.black),
              onPressed: () => Get.to(() => FavoritesPage()),
            ),
          ),
          SizedBox(width: 10), // Space between icons
          CircleAvatar(
            backgroundColor: Colors.grey[100],
            // Light White BG
            child: IconButton(
              icon: const Icon(CupertinoIcons.cart, color: Colors.black),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CartScreen())),
            ),
          ),
        ],

      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300, width: 2),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Hero(
                  tag: widget.product.productId,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: widget.product.productImages.isNotEmpty
                        ? widget.product.productImages[0]
                        : 'https://via.placeholder.com/150',
                    placeholder: (context, url) =>
                        Center(child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.product.productName,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: addFavorite,
                  icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                      size: 35),
                )
              ],
            ),
            SizedBox(height: 8),
            Text(
              widget.product.fullPrice,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.pink[400],
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              widget.product.productDescription ?? 'No description available.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: isInCart ? removeFromCart : addToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: isInCart ? Colors.blueGrey : Colors.pink[400],

                minimumSize: Size(160, 50), // Adjust width and height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(isInCart ? 'Go to Cart' : 'Add to Cart',
                  style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () => Get.to(
                  () => SingleProductsOrders(productModel: widget.product)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[400],
                minimumSize: Size(160, 50), // Adjust width and height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Buy Now', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkProductExistence() async {
    if (user == null) return;
    final snapshot = await FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders')
        .doc(widget.product.productId)
        .get();
    setState(() => isInCart = snapshot.exists);
  }

  Future<void> addToCart() async {
    if (user == null) return;
    await FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders')
        .doc(widget.product.productId)
        .set({
      'productQuantity': 1,
      'productTotalPrice': double.parse(widget.product.fullPrice),
      ...widget.product.toMap(),
    });
    setState(() => isInCart = true);
    Get.snackbar("Successfully Added", "Added to cart",
        backgroundColor: Colors.white, colorText: Colors.green);
  }

  Future<void> removeFromCart() async {
    if (user == null) return;
    await FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders')
        .doc(widget.product.productId)
        .delete();
    setState(() => isInCart = false);
    Get.snackbar("Successfully Removed", "Removed from cart",
        backgroundColor: Colors.white, colorText: Colors.red);
  }

  void addFavorite() {
    setState(() => isFavorite = !isFavorite);
    if (user != null) {
      final ref = FirebaseFirestore.instance
          .collection('favorites')
          .doc(user!.uid)
          .collection('favoriteProducts')
          .doc(widget.product.productId);
      isFavorite ? ref.set(widget.product.toMap()) : ref.delete();
      Get.snackbar("Success",
          isFavorite ? "Added to Favorites" : "Removed from Favorites");
    }
  }

  Future<void> checkFavoriteExistence() async {
    if (user == null) return;
    final snapshot = await FirebaseFirestore.instance
        .collection('favorites')
        .doc(user!.uid)
        .collection('favoriteProducts')
        .doc(widget.product.productId)
        .get();
    setState(() => isFavorite = snapshot.exists);
  }
}
