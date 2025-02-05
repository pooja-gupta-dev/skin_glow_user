import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/view/login/login.dart';
import '../../controller/user_controller.dart';

class RegistrationScreen extends StatelessWidget {
  final SignUpController authController = Get.put(SignUpController());
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('Register',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.pink[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: GestureDetector(
                  onTap: () => authController.showImagePickerOptions(context),
                  child: Obx(() {
                    return CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.orange.shade100,
                      backgroundImage: authController.imageFile.value != null
                          ? FileImage(authController.imageFile.value!)
                          : null,
                      child: authController.imageFile.value == null
                          ? Icon(
                        Icons.camera_alt,
                        color: Colors.orange.shade600,
                        size: 40,
                      )
                          : null,
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),

              // Input Fields
              _buildTextField(usernameController, 'Username', Icons.person),
              const SizedBox(height: 10),
              _buildTextField(emailController, 'Email', Icons.email),
              const SizedBox(height: 10),
              _buildTextField(phoneController, 'Phone', Icons.phone),
              const SizedBox(height: 10),
              _buildTextField(addressController, 'Address', Icons.home),
              const SizedBox(height: 10),
              _buildTextField(passwordController, 'Password', Icons.lock,
                  isPassword: true),
              const SizedBox(height: 20),

              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: authController.isLoading.value
                        ? null
                        : () {
                      authController.signUp(
                        usernameController.text.trim(),
                        emailController.text.trim(),
                        phoneController.text.trim(),
                        passwordController.text.trim(),
                        addressController.text.trim(),
                      );
                    },
                    child: authController.isLoading.value
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text('Register',style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[600],
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                );
              }),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("I have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.pink[600]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }
}