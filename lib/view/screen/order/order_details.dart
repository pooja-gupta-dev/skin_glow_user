import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../model/order_model.dart';
class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Order Details",
            style:TextStyle(color: Colors.white)
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.pink[400],
        elevation: 3,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          order.productImages[0],
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      order.productName,
                      style: GoogleFonts.poppins(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      order.productDescription,
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.grey[400]),
                    ),
                    SizedBox(height: 16),
                    Divider(thickness: 1),
                    _orderDetailRow(Icons.attach_money, "Total Price",
                        "₹${order.productTotalPrice.toStringAsFixed(2)}"),
                    _orderDetailRow(
                        Icons.numbers, "Quantity","₹order.productQuantity"),
                    _orderDetailRow(
                        Icons.person, "Customer Name", order.customerName),
                    _orderDetailRow(Icons.email, "Email", order.customerEmail),
                    _orderDetailRow(Icons.phone, "Phone", order.customerPhone),
                    _orderDetailRow(
                        Icons.location_on, "Address", order.customerAddress),
                    SizedBox(height: 8),
                    _statusBadge(order.status),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.pink[400]),
          SizedBox(width: 12),
          Text(
            label,
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Spacer(),
          Text(
            value,
            style: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(bool status) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: status ? Colors.green[100] : Colors.orange[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          status ? "Delivered" : "Pending",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: status ? Colors.green[800] :
            Colors.orange[800],
          ),
        ),
      ),
    );
  }
}
