


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../model/product_model.dart';
import '../bottomNavigationn/product_details_scree.dart';
import '../home/home_screen.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = ""; // Search query
  final TextEditingController _searchController = TextEditingController();
  int cartItemCount = 5; // Example count for cart items (replace with dynamic data)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[400],
        title: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase(); // Update the query
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: "Search for products...",
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.close, // Close icon
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _searchController.clear(); // Clears the text field
                    _searchQuery = ""; // Resets the search query
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Products Found'));
          }

          // Filter products based on the search query
          final products = snapshot.data!.docs
              .map((doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>))
              .where((product) =>
          _searchQuery.isEmpty ||
              (product.productName?.toLowerCase().contains(_searchQuery) ?? false) ||
              (product.productDescription.toLowerCase().contains(_searchQuery) ?? false))
              .toList();

          if (products.isEmpty) {
            return const Center(child: Text('No matching products found.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsScreen(
                        product: product,
                      ),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                          child: CachedNetworkImage(
                            placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error, color: Colors.red),
                            imageUrl: product.productImages.isNotEmpty
                                ? product.productImages[0]
                                : 'https://via.placeholder.com/150',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          product.productName,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '\$${product.fullPrice}',
                          style: const TextStyle(color: Colors.pink),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
