import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common/extension.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/view/login/login_view.dart';

import '../../common/globs.dart';
import '../../common/service_call.dart';
import '../../common_widget/round_textfield.dart';
import '../on_boarding/on_boarding_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  File? _image;
  TextEditingController txtName = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null){
      PlatformFile file = result.files.single;
      print(file.path);
    }


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 64),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null ? Icon(Icons.add_a_photo) : null,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Sign Up",
                style: TextStyle(color: TColor.primaryText, fontSize: 30, fontWeight: FontWeight.w800),
              ),
              Text(
                "Add your details to sign up",
                style: TextStyle(color: TColor.secondaryText, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 25),
              RoundTextfield(
                hintText: "Name",
                controller: txtName,
              ),
              const SizedBox(height: 25),
              RoundTextfield(
                hintText: "Email",
                controller: txtEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 25),
              RoundTextfield(
                hintText: "Mobile No",
                controller: txtMobile,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 25),
              RoundTextfield(
                hintText: "Address",
                controller: txtAddress,
              ),
              const SizedBox(height: 25),
              RoundTextfield(
                hintText: "Password",
                controller: txtPassword,
                obscureText: true,
              ),
              const SizedBox(height: 25),
              RoundTextfield(
                hintText: "Confirm Password",
                controller: txtConfirmPassword,
                obscureText: true,
              ),
              const SizedBox(height: 25),
              RoundButton(title: "Sign Up", onPressed: () {
                btnSignUp();
              }),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginView(),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Already have an Account? ",
                      style: TextStyle(color: TColor.secondaryText, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Login",
                      style: TextStyle(color: TColor.primary, fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  //TODO: Action
  void btnSignUp() async {
    // Perform validation checks on user input fields
    if (txtName.text.isEmpty ||
        !txtEmail.text.isEmail ||
        txtMobile.text.isEmpty ||
        txtAddress.text.isEmpty ||
        txtPassword.text.length < 6 ||
        txtPassword.text != txtConfirmPassword.text) {
      // Show appropriate error messages if validation fails
      mdShowAlert(Globs.appName, "Invalid input. Please check your details.", () {});
      return;
    }

    // Call Firebase Authentication to create a new user with email and password
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: txtEmail.text,
        password: txtPassword.text,
      );

      // Check if user creation is successful
      if (userCredential.user != null) {
        // If successful, store additional user data (name, mobile, address) in Firebase database
        await saveUserDataToFirebase(userCredential.user!.uid);

        // Navigate to the next screen upon successful sign up
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const OnBoardingView(),
          ),
              (route) => false,
        );
      } else {
        // Handle the case where user creation fails
        mdShowAlert(Globs.appName, "Failed to create user account. Please try again.", () {});
      }
    } catch (e) {
      // Handle errors that occur during user creation
      print("Error creating user: $e");
      mdShowAlert(Globs.appName, "An error occurred during sign-up. Please try again later.", () {});
    }
  }

  Future<void> saveUserDataToFirebase(String userId) async {
    // Reference to the Firebase database instance
    final database = FirebaseFirestore.instance;

    // Define the data to be stored for the user
    Map<String, dynamic> userData = {
      "name": txtName.text,
      "email": txtEmail.text,
      "mobile": txtMobile.text,
      "address": txtAddress.text,
      "password": txtPassword.text,
      "usertype": "user",
    };

    try {
      // Store user data in the 'users' collection in Firestore
      await database.collection('users').doc(userId).set(userData);
    } catch (e) {
      // Handle errors that occur during data storage
      print("Error saving user data to Firebase: $e");
      throw e;
    }
  }

}