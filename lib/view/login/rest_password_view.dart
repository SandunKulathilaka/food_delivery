import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common/extension.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/view/login/otp_view.dart';
import '../../common/globs.dart';
import '../../common/service_call.dart';
import '../../common_widget/round_textfield.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({Key? key}) : super(key: key);

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  TextEditingController txtEmail = TextEditingController();

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
              Text(
                "Reset Password",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Please enter your email to receive a reset code to create a new password via email",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 60),
              RoundTextfield(
                hintText: "Your Email",
                controller: txtEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 30),
              RoundButton(
                title: "Send",
                onPressed: () {
                  btnSubmit();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void btnSubmit() {
    if (!txtEmail.text.isEmail) {
      mdShowAlert(Globs.appName, MSG.enterEmail, () {});
      return;
    }

    endEditing();

    // Call the function to request a password reset
    requestPasswordReset(txtEmail.text);
  }

  void requestPasswordReset(String email) {
    // Use Firebase Authentication to send a password reset email
    FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) {
      // If the email is sent successfully, navigate to the OTP view
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPView(email: email),
        ),
      );
    }).catchError((error) {
      // Handle errors if the email could not be sent
      mdShowAlert(
        Globs.appName,
        "Failed to send password reset email. Please try again later.",
            () {},
      );
    });
  }
}
