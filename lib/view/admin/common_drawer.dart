import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/view/admin/admin_home_view.dart';
import 'package:food_delivery/view/admin/manage_orders.dart';
import 'package:food_delivery/view/admin/user_management.dart';

import 'admin_profile.dart';
import 'manage_inquries.dart';
import 'menu_management.dart';

class MyDrawer extends StatefulWidget {

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String? email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      email = _firebaseAuth.currentUser?.email;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepOrange,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/img/tab_profile.png'),
                ),
                SizedBox(height: 10),
                Text(
                  'Welcome',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Text(
                  '${email}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminHomePage(),
                ),
              );
            },
          ),
          SizedBox(height: 20,),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminProfile(),
                ),
              );
            },
          ),
          SizedBox(height: 20,),
          ListTile(
            leading: Icon(Icons.supervised_user_circle_sharp),
            title: Text('Manage Users'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserManagement(),
                ),
              );
            },
          ),
          SizedBox(height: 20,),
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Manage Menu'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManageMenu(),
                ),
              );
              },
          ),
          SizedBox(height: 20,),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Manage Inquries'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManageInquries(),
                ),
              );
            },
          ),
          SizedBox(height: 20,),
          ListTile(
            leading: Icon(Icons.add_shopping_cart_outlined),
            title: Text('Manage Orders'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManageOrders(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}