import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_textfield.dart';
import '../more/my_order_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ImagePicker picker = ImagePicker();
  XFile? image;

  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getTheUserDetails();
  }

  Future<void> getTheUserDetails() async {
    // Get the currently logged-in user
    User? currentUser = _firebaseAuth.currentUser;

    if (currentUser != null) {
      // Fetch the user details from Firestore
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await _firestore.collection('users').doc(currentUser.uid).get();

      if (userSnapshot.exists) {
        // Fill the text fields with user details
        Map<String, dynamic> userData = userSnapshot.data()!;
        setState(() {
          txtName.text = userData['name'] ?? '';
          txtEmail.text = userData['email'] ?? '';
          txtMobile.text = userData['mobile'] ?? '';
          txtAddress.text = userData['address'] ?? '';
          txtPassword.text = userData['password'] ?? '';
        });

      }
    }
  }

  Future<void> updateUserDetails() async {
    // Get the currently logged-in user
    User? currentUser = _firebaseAuth.currentUser;

    if (currentUser != null) {
      // Update user details in Firestore
      await _firestore.collection('users').doc(currentUser.uid).update({
        'name': txtName.text.trim(),
        'mobile': txtMobile.text.trim(),
        'address': txtAddress.text.trim(),
        'password': txtPassword.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 46),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Profile",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyOrderView(),
                          ),
                        );
                      },
                      icon: Image.asset(
                        "assets/img/shopping_cart.png",
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: TColor.placeholder,
                  borderRadius: BorderRadius.circular(50),
                ),
                alignment: Alignment.center,
                child: image != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.file(
                    File(image!.path),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                )
                    : Icon(
                  Icons.person,
                  size: 65,
                  color: TColor.secondaryText,
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  image = await picker.pickImage(source: ImageSource.gallery);
                  setState(() {});
                },
                icon: Icon(
                  Icons.edit,
                  color: TColor.primary,
                  size: 12,
                ),
                label: Text(
                  "Edit Profile",
                  style: TextStyle(color: TColor.primary, fontSize: 12),
                ),
              ),
              Text(
                "${_firebaseAuth.currentUser!.email}",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Sign Out",
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                ),
                child: RoundTitleTextfield(
                  title: "Name",
                  hintText: "Enter Name",
                  controller: txtName,
                  enabled: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                ),
                child: RoundTitleTextfield(
                  title: "Email",
                  hintText: "Enter Email",
                  keyboardType: TextInputType.emailAddress,
                  controller: txtEmail,
                  enabled: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                ),
                child: RoundTitleTextfield(
                  title: "Mobile No",
                  hintText: "Enter Mobile No",
                  controller: txtMobile,
                  keyboardType: TextInputType.phone,
                  enabled: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                ),
                child: RoundTitleTextfield(
                  title: "Address",
                  hintText: "Enter Address",
                  controller: txtAddress,
                  enabled: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                ),
                child: RoundTitleTextfield(
                  title: "Password",
                  hintText: "* * * * * *",
                  obscureText: true,
                  controller: txtPassword,
                  enabled: true,
                ),
              ),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RoundButton(
                  title: "Save",
                  onPressed: () {
                    updateUserDetails();
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
