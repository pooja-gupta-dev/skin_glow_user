// class ProductModel {
//   final String productName;
//   final String description;
//   final List<String> productImages;
//   final double fullPrice;
//   final String productDescription;
//
//   ProductModel({
//     required this.productName,
//     required this.description,
//     required this.productImages,
//     required this.fullPrice,
//     required this.productDescription,
//   });
//
//   factory ProductModel.fromJson(Map<String, dynamic> json) {
//     return ProductModel(
//       productName: json['productName'] ?? '',
//       description: json['description'] ?? '',
//       productDescription: json[' productDescription']??'',
//       productImages: List<String>.from(json['productImages'] ?? []),
//       fullPrice: (json['fullPrice'] ?? 0).toDouble(),
//     );
//   }
// }
