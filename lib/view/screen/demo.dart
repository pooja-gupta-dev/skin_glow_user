import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widget/cutom_textfield.dart';

class AddProductScreen extends StatelessWidget {
  final ProductController controller =
  Get.put(ProductController());

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:Color(0xFFFFD700),
        title: Text(
          "Add new Product",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SERVICES PHOTO",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: screenHeight * 0.01),
              GestureDetector(
                onTap: controller.pickImage,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: Obx(() {
                    return controller.selectedImage.value == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 70,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Add',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        controller.selectedImage.value!,
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomTextField(
                  label: "PRODUCT NAME",
                  hintText: "Enter Product Name",
                  inputType: TextInputType.text,
                  controller: controller.productNameController,
                icon: CupertinoIcons.person,),

              SizedBox(height: screenHeight * 0.02),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                        icon: CupertinoIcons.person,
                        label: "FULL PRICE",
                        hintText: "Enter full price",
                        inputType: TextInputType.number,
                        controller: controller.fullPriceController),
                  ),
                  SizedBox(width: screenWidth * 0.04),

                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomTextField(
                  icon: CupertinoIcons.person,
                  label: "SERVICES DESCRIPTION",
                  hintText: "Enter description",
                  inputType: TextInputType.text,
                  controller: controller.productDescriptionController),

              SizedBox(height: screenHeight * 0.03),
              SizedBox(
                width: double.infinity,
                child: Obx(() {
                  return CustomButton(
                    text:
                    controller.isLoading.value ? "Saving..." : 'SAVE NEXT',
                    onPressed: controller.isLoading.value
                        ? () {} // Provide an empty callback when loading
                        : () {
                      // Validation
                      if (controller.productNameController.text.isEmpty ||
                          controller.fullPriceController.text.isEmpty ||
                          controller.productDescriptionController.text
                              .isEmpty
                      ) {
                        Get.snackbar(
                          "Error",
                          "Please fill all the required fields",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }

                      // Call the asynchronous function inside the synchronous callback
                      controller.saveProduct();
                    },
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}




class ProductController extends GetxController {
  var selectedImage = Rxn<File>();

  var productNameController = TextEditingController();
  var fullPriceController = TextEditingController();
  var productDescriptionController = TextEditingController();

  var isLoading = false.obs;  // Track loading state

  @override
  void onInit() {
    super.onInit();
  }


  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  Future<String?> uploadImage() async {
    if (selectedImage.value == null) return null;

    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();  // Unique file name
      final uploadTask = FirebaseStorage.instance
          .ref('products_images/$fileName')
          .putFile(selectedImage.value!);

      final snapshot = await uploadTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> saveProduct() async {
    isLoading.value = true;

    final productId = FirebaseFirestore.instance.collection('products').doc().id;
    final downloadUrl = await uploadImage();

    final newProduct = {
      'productId': productId,
      'productName': productNameController.text,
      'fullPrice': fullPriceController.text,
      'productImages': downloadUrl != null ? [downloadUrl] : [],
      'productDescription': productDescriptionController.text,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance.collection('products').doc(productId).set(newProduct);
      Get.snackbar("Success", "Product added successfully", snackPosition: SnackPosition.TOP);
      clearForm();
    } catch (e) {
      Get.snackbar("Error", "There was an issue saving the product. Please try again.", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    productNameController.clear();
    fullPriceController.clear();
    productDescriptionController.clear();
    selectedImage.value = null;
  }
}





class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:Color(0xFFFFD700),
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.02),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: screenWidth * 0.045,
          color: Colors.white,
        ),
      ),
    );
  }
}
