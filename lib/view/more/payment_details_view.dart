import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_icon_button.dart';
import 'package:food_delivery/view/more/add_card_view.dart';

import '../../common_widget/round_button.dart';
import 'my_order_view.dart';

class PaymentDetailsView extends StatefulWidget {
  const PaymentDetailsView({super.key});

  @override
  State<PaymentDetailsView> createState() => _PaymentDetailsViewState();
}

class _PaymentDetailsViewState extends State<PaymentDetailsView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> cardArr = [];

  @override
  void initState() {
    super.initState();
    // Call the function to fetch card details for the current user
    fetchUserCardDetails();
  }

  Future<void> fetchUserCardDetails() async {
    try {
      // Get the currently logged-in user
      String? user = _auth.currentUser?.email;
      if (user != null) {
        // Access the 'cards' collection in Firestore
        CollectionReference cardsCollection =
        FirebaseFirestore.instance.collection('cards');

        // Query cards collection filtered by user ID
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await cardsCollection.where('user', isEqualTo: user).get() as QuerySnapshot<Map<String, dynamic>>;

        // Iterate through the documents and add card details to cardArr
        querySnapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> document) {
          cardArr.add({
            'cardId': document.id,
            'cardNumber': document.data()?['cardNumber'],
            'expiryMonth': document.data()?['expiryMonth'],
            'expiryYear': document.data()?['expiryYear'],
            'securityCode': document.data()?['securityCode'],
            'firstName': document.data()?['firstName'],
            'lastName': document.data()?['lastName'],
            'canRemoveAnyTime': document.data()?['canRemoveAnyTime'],
            // Add any other relevant fields
          });
        });

        // Update the state to trigger UI rebuild with the fetched card details
        setState(() {});
      }
    } catch (error) {
      // Handle errors that occur during data fetching
      print('Error fetching user card details: $error');
    }
  }

  void deleteCard(String cardId) async {
    try {
      // Access the 'cards' collection in Firestore
      CollectionReference cardsCollection = FirebaseFirestore.instance.collection('cards');

      // Delete the card document with the specified cardId
      await cardsCollection.doc(cardId).delete();

      // Notify the user that the card has been successfully deleted
      showDialog(
        context: context,

        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Card deleted successfully'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      // Handle errors that occur during deletion
      print('Error deleting card: $error');
      // Notify the user that an error occurred
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to delete card. Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset("assets/img/btn_back.png",
                          width: 20, height: 20),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        "Payment Details",
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                         Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyOrderView()));
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: Text(
                  "Customize your payment method",
                  style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Divider(
                  color: TColor.secondaryText.withOpacity(0.4),
                  height: 1,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    color: TColor.textfield,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15,
                          offset: Offset(0, 9))
                    ]),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Cash/Card On Delivery",
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          ),
                          Image.asset(
                            "assets/img/check.png",
                            width: 20,
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Divider(
                        color: TColor.secondaryText.withOpacity(0.4),
                        height: 1,
                      ),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: cardArr.length,
                      itemBuilder: (context, index) {
                        var card = cardArr[index]; // Get the card details at the current index
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/img/visa_icon.png",
                                width: 50,
                                height: 35,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      card["cardNumber"], // Access cardNumber from card details
                                      style: TextStyle(
                                        color: TColor.secondaryText,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${card["firstName"]} ${card["lastName"]}", // Access firstName and lastName from card details
                                      style: TextStyle(
                                        color: TColor.secondaryText,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                height: 28,
                                child: RoundButton(
                                  title: 'Delete Card',
                                  fontSize: 12,
                                  onPressed: () {
                                    // Handle delete card functionality
                                    deleteCard('${card["cardId"]}');
                                  },
                                  type: RoundButtonType.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Divider(
                        color: TColor.secondaryText.withOpacity(0.4),
                        height: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Other Methods",
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: RoundIconButton(
                    title: "Add Another Credit/Debit Card",
                    icon: "assets/img/add.png",
                    color: TColor.primary,
                    fontSize: 16,
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return const AddCardView();
                          });
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCardView() ));
                    }),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
