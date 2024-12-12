import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/view/admin/common_drawer.dart';

class User {
  final String id;
  final String image;
  final String name;
  final String contact;
  final String address;
  final String email;
  final String usertype;
  final String lastLogin;

  User({
    required this.id,
    required this.image,
    required this.name,
    required this.contact,
    required this.address,
    required this.email,
    required this.usertype,
    required this.lastLogin,
  });

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return User(
      id: snapshot.id,
      image: data['image'] ?? '', // Null check added here
      name: data['name'] ?? '', // Null check added here
      contact: data['mobile'] ?? '', // Null check added here
      address: data['address'] ?? '', // Null check added here
      email: data['email'] ?? '', // Null check added here
      usertype: data['usertype'] ?? '', // Null check added here
      lastLogin: data['lastLogin'] ?? '', // Null check added here
    );
  }
}

class UserManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Users'),
      ),
      drawer: MyDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
          final List<User> users = snapshot.data!.docs
              .map((doc) => User.fromSnapshot(doc))
              .toList();
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return UserListItem(user: users[index]);
            },
          );
        },
      ),
    );
  }
}

class UserListItem extends StatelessWidget {
  final User user;

  const UserListItem({Key? key, required this.user}) : super(key: key);

  Future<void> _deleteUser(BuildContext context, String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete user: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(user.image),
      ),
      title: Text(user.name),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(user.email),
          Text("2024/05/05"),
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
                        _deleteUser(context, user.id);
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              // Show user details in an alert dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('User Details'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Name: ${user.name}'),
                      Text('Email: ${user.email}'),
                      Text('Last Login: ${user.lastLogin}'),
                      Text('Address: ${user.address}'),
                      Text('Contact No: ${user.contact}'),
                      Text('User Type: ${user.usertype}'),
                      // Add more details if needed
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Close'),
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
