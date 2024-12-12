import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_textfield.dart';
import '../../common_widget/round_button.dart';
import 'my_order_view.dart';

class InboxView extends StatefulWidget {
  @override
  State<InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends State<InboxView> {
  List inboxArr = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fetchMessagesFromFirebase();
  }

  void fetchMessagesFromFirebase() {
    print('Fetching messages for user: ${firebaseAuth.currentUser!.email}');
    FirebaseFirestore.instance
        .collection('inquries')
        .where('user', isEqualTo: firebaseAuth.currentUser?.email)
        .get()
        .then((querySnapshot) {
      print('Query returned ${querySnapshot.size} documents');
      setState(() {
        inboxArr.clear(); // Clear inboxArr before adding new items
        querySnapshot.docs.forEach((doc) {
          inboxArr.add({
            "id": doc.id, // Add document ID to identify each inquiry
            "title": doc['title'],
            "body": doc['body'],
            "email": doc['user'],
            "reply": doc['reply'],
          });
        });
      });
    }).catchError((error) {
      print("Failed to fetch inbox messages: $error");
    });
  }

  Future<void> addInquiries() async {
    try {
      await FirebaseFirestore.instance.collection('inquries').add({
        'title': _titleController.text,
        'body': _bodyController.text,
        'user': firebaseAuth.currentUser!.email,
        'reply': '', // Assuming reply is initially empty
      });
      // Clear text fields after adding inquiry
      _titleController.clear();
      _bodyController.clear();
      // Fetch inquiries again to update the list
      fetchMessagesFromFirebase();
    } catch (e) {
      print('Error adding inquiry: $e');
    }
  }

  Future<void> deleteInquiry(String id) async {
    try {
      await FirebaseFirestore.instance.collection('inquries').doc(id).delete();
      // Fetch inquiries again to update the list
      fetchMessagesFromFirebase();
    } catch (e) {
      print('Error deleting inquiry: $e');
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
                        "Inquires",
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
              SizedBox(height: 10,),
              Text('Add New Inquiries', style: TextStyle(fontSize: 18)),
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    RoundTextfield(
                      controller: _titleController,
                      hintText: 'Title',
                    ),
                    SizedBox(height: 5,),
                    RoundTextfield(
                      controller: _bodyController,
                      hintText: 'Body',
                    ),
                    SizedBox(height: 5,),
                    RoundButton(title: "Add Inquiries", onPressed: () {
                      addInquiries();
                    }),
                    SizedBox(height: 5,),
                  ],
                ),
              ),
              Text('Old Inquiries', style: TextStyle(fontSize: 18)),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: inboxArr.length,
                separatorBuilder: ((context, index) => Divider(
                  indent: 25,
                  endIndent: 25,
                  color: TColor.secondaryText.withOpacity(0.4),
                  height: 1,
                )),
                itemBuilder: ((context, index) {
                  var cObj = inboxArr[index] as Map? ?? {};
                  return GestureDetector(
                    onTap: () {
                      // Mark message as read (update in Firestore)
                      print("Message clicked: ${cObj['title']}");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: index % 4 != 1
                              ? TColor.white
                              : TColor.textfield),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 25),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                                color: TColor.primary,
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cObj["title"].toString(),
                                  style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  cObj["body"].toString(),
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: TColor.secondaryText,
                                      fontSize: 14),
                                ),
                                Text(
                                  cObj["email"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'jokerman'),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  cObj["reply"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'jokerman'),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteInquiry(cObj["id"]);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
