import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/view/login/welcome_view.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';
import '../login/login_view.dart';
import 'common_drawer.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}


class _AdminProfileState extends State<AdminProfile> {
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
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                "Admin Profile",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                child: Icon(
                  Icons.verified_user
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
                  "Edit Profile Image",
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
                onPressed: () async {
                  await _firebaseAuth.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WelcomeView(),
                    ),
                  );
                },
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

