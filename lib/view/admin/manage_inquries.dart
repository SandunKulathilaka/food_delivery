import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/view/admin/common_drawer.dart';

class ManageInquries extends StatefulWidget {
  const ManageInquries({Key? key}) : super(key: key);

  @override
  State<ManageInquries> createState() => _ManageInquries();
}

class _ManageInquries extends State<ManageInquries> {
  List inboxArr = [];

  @override
  void initState() {
    super.initState();
    fetchMessagesFromFirebase();
  }

  void fetchMessagesFromFirebase() {
    FirebaseFirestore.instance.collection('inquries').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          inboxArr.add({
            "id": doc.id,
            "title": doc['title'],
            "body": doc['body'],
            "user": doc['user'],
            "reply": doc['reply']
          });
        });
      });
    }).catchError((error) {
      print("Failed to fetch inbox messages: $error");
    });
  }

  void addReplyToFirebase(String messageId, String reply) {
    FirebaseFirestore.instance
        .collection('inquries')
        .doc(messageId)
        .update({'reply': reply})
        .then((value) {
      print("Reply added successfully");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ManageInquries(),
        ),
      );
    }).catchError((error) {
      print("Failed to add reply: $error");
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Inquiries'),
        centerTitle: true,
        ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Center(child: Text('All Inquries',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.black),)),
              SizedBox(
                height: 46,
              ),
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
                      showDialog(
                        context: context,
                        builder: (context) {
                          TextEditingController replyController = TextEditingController();
                          return AlertDialog(
                            title: Text('Add Reply'),
                            content: TextField(
                              controller: replyController,
                              decoration: InputDecoration(
                                hintText: 'Enter your reply',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Call function to add reply to Firestore
                                  addReplyToFirebase(cObj['id'], replyController.text);
                                  Navigator.pop(context);
                                },
                                child: Text('Add'),
                              ),
                            ],
                          );
                        },
                      );
                    },

                    child: Container(
                      decoration: BoxDecoration(
                          color:
                          index % 4 != 1 ? TColor.white : TColor.textfield),
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
                                  cObj["user"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.deepOrange, fontSize: 14,fontWeight: FontWeight.bold,fontFamily: 'jokerman'),
                                ),
                                SizedBox(height: 10,),
                                Text(
                                  cObj["reply"] != null ? "Reply : ${cObj["reply"]}" : "No reply yet",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'jokerman'
                                  ),
                                ),

                              ],
                            ),
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
