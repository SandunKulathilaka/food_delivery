import 'package:flutter/material.dart';
import 'package:food_delivery/view/admin/admin_profile.dart';
import 'package:food_delivery/view/admin/common_drawer.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Overview',
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.supervised_user_circle_sharp),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminProfile(),
              ),
            ),
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                height: media.height * 0.2,
                width: media.width * 0.8,
                color: Colors.grey[200],
                padding: EdgeInsets.all(20.0), // Add padding to center the text vertically
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Complete Today',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '78',
                          style: TextStyle(fontSize: 24,color: Colors.deepOrange,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      'Total orders recived form the app shows in here',
                      style: TextStyle(fontSize: 14),
                    ),
                    InkWell(
                      onTap: () => print('Tell me more tapped'),
                      child: Text('Tell me more'),
                    ),
                  ],
                ),
              ),
              // Highlights section
              SizedBox(height: 16), // Add spacing between sections
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Highlights',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => print('View More tapped'),
                    child: Text('View More'),
                    style: TextButton.styleFrom(
                      primary: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: media.width*0.35,
                    height: 180,
                    padding: EdgeInsets.all(10.0), // Add padding to the container
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text('All Users', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            Text('11,857', style: TextStyle(fontSize: 16,color: Colors.deepOrange)),
                            Text('updated 15 min ago', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            TextButton(
                              onPressed: () => print('Overview tapped'),
                              child: Text('Overview'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: media.width*0.35,
                    height: 180,
                    padding: EdgeInsets.all(10.0), // Add padding to the container
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text('Orders Received', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            Text('12 orders today', style: TextStyle(fontSize: 16,color: Colors.deepOrange)),
                            Text('updated 50m ago', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            TextButton(
                              onPressed: () => print('Explore tapped'),
                              child: Text('Explore'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Week Section
              SizedBox(height: 16), // Add spacing between sections
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'This Week report',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => print('View More tapped'),
                    child: Text('View More'),
                    style: TextButton.styleFrom(
                      primary: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: media.width*0.35,
                    height: 120,
                    padding: EdgeInsets.all(10.0), // Add padding to the container
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.people),
                                SizedBox(width: 5,),
                                Text('New Users', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Text('2000', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,fontFamily: 'roboto',color: Colors.deepOrange)),
                            Text('updated 15 min ago', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: media.width*0.35,
                    height: 120,
                    padding: EdgeInsets.all(10.0), // Add padding to the container
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_cart),
                                SizedBox(width: 5,),
                                Text('Orders Received', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),                              ],
                            ),
                            Text('5 orders', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,fontFamily: 'roboto',color: Colors.deepOrange)),
                            Text('updated 50m ago', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: media.width*0.35,
                    height: 120,
                    padding: EdgeInsets.all(10.0), // Add padding to the container
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.money),
                                SizedBox(width: 5,),
                                Text('Revenue', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),                              ],
                            ),
                            Text('150,000', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,fontFamily: 'roboto',color: Colors.deepOrange)),
                            Text('updated 15 min ago', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: media.width*0.35,
                    height: 120,
                    padding: EdgeInsets.all(10.0), // Add padding to the container
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.handshake),
                                SizedBox(width: 5,),
                                Text('RPO', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),                              ],
                            ),
                            Text('30,000', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,fontFamily: 'roboto',color: Colors.deepOrange)),
                            Text('updated 50m ago', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),


              // Bottom section
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildHighlightColumn(String title, String value, String updateTime) {
  return Column(
    children: [
      Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      Text(value, style: TextStyle(fontSize: 16)),
      Text(updateTime, style: TextStyle(fontSize: 12, color: Colors.grey)),
    ],
  );
}
