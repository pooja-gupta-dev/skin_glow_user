class CartModel {
  final String productId;
  final String productName;

  final String fullPrice;
  final List productImages;
  final String productDescription;
  final dynamic createdAt;
  final dynamic updatedAt;
  late final int productQuantity;
  late final double productTotalPrice;

  CartModel({
    required this.productName,
    required this.productId,
    required this.fullPrice,
    required this.productImages,
    required this.productDescription,
    required this.createdAt,
    required this.updatedAt,
    required this.productQuantity,
    required this.productTotalPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'productId': productId,
      'fullPrice': fullPrice,
      'productImages': productImages,
      'productDescription': productDescription,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'productQuantity': productQuantity,
      'productTotalPrice': productTotalPrice,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> json) {
    return CartModel(
      productId: json['productId'],
      fullPrice: json['fullPrice'],
      productImages: json['productImages'],
      productDescription: json['productDescription'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      productQuantity: json['productQuantity'],
      productTotalPrice: json['productTotalPrice'],
      productName: json['productName'],
    );
  }
}
