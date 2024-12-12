import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'common_drawer.dart';

class Order {
  final String id;
  final String image;
  final String items;
  final String contact;
  final String address;
  final String email;
  final String usertype;
  final String status;

  Order({
    required this.id,
    required this.image,
    required this.contact,
    required this.address,
    required this.email,
    required this.usertype,
    required this.status,
    required this.items,
  });

  factory Order.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Order(
      id: snapshot.id,
      image: data['image'] ?? '', // Null check added here
      items: data['items'] ?? '', // Null check added here
      contact: data['contact'] ?? '', // Null check added here
      address: data['address'] ?? '', // Null check added here
      email: data['email'] ?? '', // Null check added here
      usertype: data['name'] ?? '', // Null check added here
      status: data['status'] ?? '', // Null check added here
    );
  }
}

class ManageOrders extends StatefulWidget {
  const ManageOrders({Key? key}) : super(key: key);

  @override
  State<ManageOrders> createState() => _ManageOrdersState();
}

class _ManageOrdersState extends State<ManageOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Orders'),
      ),
      drawer: MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Pending Orders'),
            onTap: () {
              // Navigate to pending orders screen
            },
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('orders').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                final List<Order> orders = snapshot.data!.docs
                    .map((doc) => Order.fromSnapshot(doc))
                    .toList();
                final pendingOrders = orders.where((order) => order.status == 'pending').toList();
                return ListView.builder(
                  itemCount: pendingOrders.length,
                  itemBuilder: (context, index) {
                    return UserListItem(order: pendingOrders[index]);
                  },
                );
              },
            ),
          ),
          ListTile(
            title: Text('Confirm Orders'),
            onTap: () {

            },
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('orders').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                final List<Order> orders = snapshot.data!.docs
                    .map((doc) => Order.fromSnapshot(doc))
                    .toList();
                final confirmOrders = orders.where((order) => order.status == 'confirm').toList();
                return ListView.builder(
                  itemCount: confirmOrders.length,
                  itemBuilder: (context, index) {
                    return UserListItem(order: confirmOrders[index]);
                  },
                );
              },
            ),
          ),
          ListTile(
            title: Text('Finish Orders'),
            onTap: () {
              // Navigate to finish orders screen
            },
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('orders').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                final List<Order> orders = snapshot.data!.docs
                    .map((doc) => Order.fromSnapshot(doc))
                    .toList();
                final finishOrders = orders.where((order) => order.status == 'finish').toList();
                return ListView.builder(
                  itemCount: finishOrders.length,
                  itemBuilder: (context, index) {
                    return UserListItem(order: finishOrders[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class UserListItem extends StatelessWidget {
  final Order order;

  const UserListItem({Key? key, required this.order}) : super(key: key);

  Future<void> _deleteUser(BuildContext context, String userId) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(userId).delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete order: $e'),
      ));
    }
  }

  void addReplyToFirebase(String messageId, String reply) {
    FirebaseFirestore.instance
        .collection('orders')
        .doc(messageId)
        .update({'status': reply})
        .then((value) {
      print("Order added successfully");
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => ManageOrders(),
      //   ),
      // );
    }).catchError((error) {
      print("Failed to add reply: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(order.image),
      ),
      title: Text(order.items),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(order.email),
          Text('Order Status: ${order.status}'),
          Text('Address: ${order.address}'),
          Text('Contact No: ${order.contact}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Delete User'),
                  content: Text('Are you sure you want to delete this user?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _deleteUser(context, order.id);
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.check, color: Colors.green,),
            onPressed: () {
              // Show user details in an alert dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Confirm Order !!'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Name: ${order.items}'),
                      Text('Email: ${order.email}'),
                      Text('Status: ${order.status}'),
                      Text('Address: ${order.address}'),
                      Text('Contact No: ${order.contact}'),
                      // Add more details if needed
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Check the order status
                        if (order.status == 'confirm') {
                          // If status is 'confirm', pass 'finish' as value
                          addReplyToFirebase(order.id, 'finish');
                        } else {
                          // Otherwise, pass 'confirm'
                          addReplyToFirebase(order.id, 'confirm');
                        }
                        Navigator.pop(context);
                      },
                      child: Text(order.status == 'confirm' ? 'Finish' : 'Confirm'),
                    ),
                  ],
                ),
              );
            },
          ),

        ],
      ),
    );
  }
}
