import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_icon_button.dart';
import 'package:food_delivery/common_widget/round_textfield.dart';
import 'package:food_delivery/view/more/payment_details_view.dart';

class AddCardView extends StatefulWidget {
  const AddCardView({super.key});

  @override
  State<AddCardView> createState() => _AddCardViewState();
}

class _AddCardViewState extends State<AddCardView> {
  TextEditingController txtCardNumber = TextEditingController();
  TextEditingController txtCardMonth = TextEditingController();
  TextEditingController txtCardYear = TextEditingController();
  TextEditingController txtCardCode = TextEditingController();
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  bool isAnyTime = false;

  Future<void> addCardToFirestore() async {
    try {
      // Access the 'cards' collection in Firestore
      CollectionReference cardsCollection =
      FirebaseFirestore.instance.collection('cards');
      final FirebaseAuth _firebaseauth = FirebaseAuth.instance;

      // Add the card details to Firestore
      await cardsCollection.add({
        'user': _firebaseauth.currentUser?.email,
        'cardNumber': txtCardNumber.text,
        'expiryMonth': txtCardMonth.text,
        'expiryYear': txtCardYear.text,
        'securityCode': txtCardCode.text,
        'firstName': txtFirstName.text,
        'lastName': txtLastName.text,
        'canRemoveAnyTime': isAnyTime,
        // Add any other relevant fields
      });
      // Navigate to the payment details screen on success
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PaymentDetailsView()),
      );
    } catch (error) {
      // Handle errors that occur during card addition
      print('Error adding card to Firestore: $error');
      // Display a dialog box for unsuccessful payment
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Payment Unsuccessful"),
            content: Text("Failed to add card. Please try again."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return  Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        width: media.width,
        decoration: BoxDecoration(
            color: TColor.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Add Credit/Debit Card",
                  style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: TColor.primaryText,
                    size: 25,
                  ),
                )
              ],
            ),
            Divider(
              color: TColor.secondaryText.withOpacity(0.4),
              height: 1,
            ),
            const SizedBox(
              height: 15,
            ),
            RoundTextfield(
              hintText: "Card Number",
              controller: txtCardNumber,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text(
                  "Expiry",
                  style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                SizedBox(
                  width: 100,
                  child: RoundTextfield(
                    hintText: "MM",
                    controller: txtCardMonth,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 25),
                SizedBox(
                  width: 100,
                  child: RoundTextfield(
                    hintText: "YYYY",
                    controller: txtCardYear,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            RoundTextfield(
              hintText: "Card Security Code",
              controller: txtCardCode,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 15,
            ),
            RoundTextfield(
              hintText: "First Name",
              controller: txtFirstName,
            ),
            const SizedBox(
              height: 15,
            ),
            RoundTextfield(
              hintText: "Last Name",
              controller: txtLastName,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(children: [
              Text(
                "You can remove this card at anytime",
                style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Switch(
                  value: isAnyTime,
                  activeColor: TColor.primary,
                  onChanged: (newVal) {
                    setState(() {
                      isAnyTime = newVal;
                    });
                  })
            ]),
            const SizedBox(
              height: 25,
            ),
            RoundIconButton(
                title: "Add Card",
                icon: "assets/img/add.png",
                color: TColor.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                onPressed: () {
                  addCardToFirestore();
                }),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      
    );
  }
}
