class OrderDetailModel {
  final String productId;
  final String productName;
  final double fullPrice;
  final List<String> productImages;
  final String productDescription;
  final String createdAt;
  final String updatedAt;
  final int productQuantity;
  final double productTotalPrice;
  final String customerId;
  final bool status;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String customerEmail;

  OrderDetailModel({
    required this.productId,
    required this.productName,
    required this.fullPrice,
    required this.productImages,
    required this.productDescription,
    required this.createdAt,
    required this.updatedAt,
    required this.productQuantity,
    required this.productTotalPrice,
    required this.customerId,
    required this.status,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.customerEmail,
  });

  factory OrderDetailModel.fromMap(Map<String, dynamic> map) {
    return OrderDetailModel(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      fullPrice: (map['fullPrice'] ?? 0).toDouble(),
      productImages: List<String>.from(map['productImages'] ?? []),
      productDescription: map['productDescription'] ?? '',
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
      productQuantity: map['productQuantity'] ?? 0,
      productTotalPrice: (map['productTotalPrice'] ?? 0).toDouble(),
      customerId: map['customerId'] ?? '',
      status: map['status'] ?? false,
      customerName: map['customerName'] ?? '',
      customerPhone: map['customerPhone'] ?? '',
      customerAddress: map['customerAddress'] ?? '',
      customerEmail: map['customerEmail'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'fullPrice': fullPrice,
      'productImages': productImages,
      'productDescription': productDescription,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'productQuantity': productQuantity,
      'productTotalPrice': productTotalPrice,
      'customerId': customerId,
      'status': status,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'customerEmail': customerEmail,
    };
  }
}
