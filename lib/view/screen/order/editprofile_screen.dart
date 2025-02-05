import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../controller/user_controller.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final SignUpController controller = Get.find<SignUpController>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  File? _imageFile;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    nameController.text = controller.userModel.value.username ?? "";
    emailController.text = controller.userModel.value.email ?? "";
    phoneController.text = controller.userModel.value.phone ?? "";
    addressController.text = controller.userModel.value.userAddress ?? "";
    _profileImageUrl = controller.userModel.value.userImg ?? "";
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadProfilePicture(String uid) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('profile_images/$uid.jpg');
      UploadTask uploadTask = storageRef.putFile(_imageFile!);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  Future<void> updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String imageUrl = _profileImageUrl ?? '';
          if (_imageFile != null) {
            imageUrl = await _uploadProfilePicture(user.uid);
          }

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            'username': nameController.text.trim(),
            'phone': phoneController.text.trim(),
            'userAddress': addressController.text.trim(),
            'userImg': imageUrl,
          });

          await controller.fetchUserData();
          setState(() {
            _profileImageUrl = imageUrl;
          });

          Get.back();
          Get.snackbar("Success", "Profile updated successfully",
              backgroundColor: Colors.green, colorText: Colors.white);
        }
      } catch (e) {
        print(e);
        Get.snackbar("Error", "Failed to update profile",
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Edit Profile", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.pink[400],
        elevation: 5,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Colors.pink.shade200,
                              Colors.purple.shade400
                            ],
                          ),
                        ),
                        padding: EdgeInsets.all(3),
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.white,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : (_profileImageUrl != null &&
                                      _profileImageUrl!.isNotEmpty
                                  ? NetworkImage(_profileImageUrl!)
                                  : null),
                          child: _imageFile == null &&
                                  (_profileImageUrl == null ||
                                      _profileImageUrl!.isEmpty)
                              ? Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.white,
                                  child: Icon(Icons.camera_alt,
                                      color: Colors.grey, size: 40),
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 4),
                            ],
                          ),
                          child: Icon(Icons.camera_alt,
                              color: Colors.pink[600], size: 28),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(nameController, "Full Name", Icons.person),
                    SizedBox(height: 12),
                    _buildTextField(emailController, "Email", Icons.email,
                        isEnabled: false),
                    SizedBox(height: 12),
                    _buildTextField(phoneController, "Phone", Icons.phone),
                    SizedBox(height: 12),
                    _buildTextField(addressController, "Address", Icons.home),
                  ],
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: updateProfile,
                  child: Text("Save Changes",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Colors.pink[600],
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isEnabled = true}) {
    return TextFormField(
      controller: controller,
      enabled: isEnabled,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.pink[600]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pink[600]!),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label cannot be empty";
        }
        return null;
      },
    );
  }
}

class Shimmer {
  static fromColors(
      {required Color baseColor,
      required Color highlightColor,
      required Icon child}) {}
}
