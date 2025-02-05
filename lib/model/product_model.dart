class ProductModel {
  final String productId;
  final String productName;
  final String fullPrice;
  final List productImages;
  final String productDescription;
  final dynamic createdAt;
  final dynamic updatedAt;
  bool? isFavorite;

  ProductModel({
    this.isFavorite,
    required this.productId,
    required this.productName,
    required this.fullPrice,
    required this.productImages,
    required this.productDescription,
    required this.createdAt,
    required this.updatedAt,
  });




  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'fullPrice': fullPrice,
      'productImages': productImages,
      'productDescription': productDescription,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isFavorite':isFavorite,

    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        productId: json['productId'],

        productName: json['productName'],
        fullPrice: json['fullPrice'],
        productImages: json['productImages'],
        productDescription: json['productDescription'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        isFavorite: json['isFavorite'] ?? false);

  }
}
