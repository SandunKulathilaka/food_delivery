import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:food_delivery/common_widget/round_textfield.dart';

import '../../common_widget/round_button.dart';
import 'common_drawer.dart';

class ManageMenu extends StatefulWidget {
  const ManageMenu({ key}) : super(key: key);

  @override
  State<ManageMenu> createState() => _ManageMenuState();
}

class _ManageMenuState extends State<ManageMenu> {
  List _categories = []; // Initialize empty list

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _imageUrlController = TextEditingController();
  TextEditingController _itemCountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCategories(); // Call the function to fetch categories when the widget initializes
  }

  // Function to fetch categories from Firestore
  Future<void> _fetchCategories() async {
    try {
      // Fetch data from Firestore collection 'categories'
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('categories').get();
      setState(() {
        // Update _categories list with the fetched data
        _categories = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  // Function to add category to Firestore
  Future<void> _addCategory() async {
    try {
      await FirebaseFirestore.instance.collection('categories').add({
        'name': _nameController.text,
        'imgUrl': _imageUrlController.text,
        'id': int.parse(_itemCountController.text),
      });
      // Clear text fields after adding category
      _nameController.clear();
      _imageUrlController.clear();
      _itemCountController.clear();
      // Fetch categories again to update the list
      _fetchCategories();
    } catch (e) {
      print('Error adding category: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Menu'),
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  RoundTextfield(
                    hintText: "Category Name",
                    controller: _nameController,
                  ),
                  SizedBox(height: 10,),
                  RoundTextfield(
                    controller: _imageUrlController,
                    hintText: "Image Url",
                  ),
                  SizedBox(height: 10),
                  RoundTextfield(
                    controller: _itemCountController,
                    hintText: "Category Id",
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  RoundButton(title: "Add Categories", onPressed: () {
                    _addCategory();
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Product Categories',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return _buildCategoryItem(_categories[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey.shade200,
      ),
      child: Stack(
        children: [
          // Product category image
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              category['imgUrl'],
              width: double.infinity,
              height: 125.0,
              fit: BoxFit.cover,
            ),
          ),
          // Category title
          Positioned(
            bottom: 10.0,
            left: 5.0,
            child: Text(
              category['name'],
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Total item count
          Positioned(
            bottom: 5.0,
            right: 5.0,
            child: Chip(
              label: Text(
                '${category['id']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
              backgroundColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
