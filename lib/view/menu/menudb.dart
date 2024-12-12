import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../common/color_extension.dart';
import '../../common_widget/category_cell.dart';
import '../../common_widget/most_popular_cell.dart';
import '../../common_widget/new_menuitem_column.dart';
import '../../common_widget/round_textfield.dart';
import '../../common_widget/view_all_title_row.dart';
import '../more/my_order_view.dart';
import 'item_details_view.dart';

class ItemMenuDB extends StatefulWidget {
  const ItemMenuDB({Key? key}) : super(key: key);

  @override
  State<ItemMenuDB> createState() => _ItemMenuDBState();
}

class _ItemMenuDBState extends State<ItemMenuDB> {
  TextEditingController txtSearch = TextEditingController();
  List catArr = [];

  @override
  void initState() {
    super.initState();
    _getCategoriesFromFirebase();
  }

  Future<void> _getCategoriesFromFirebase() async {
    final db = FirebaseFirestore.instance;
    final collectionRef = db.collection('categories');

    try {
      final querySnapshot = await collectionRef.get();
      final categories = querySnapshot.docs.map((doc) => doc.data()).toList();
      setState(() {
        catArr = categories;
      });
    } catch (error) {
      print("Error getting categories: $error");
    }
  }

  List burgerArr = [
    {
      "image": "assets/img/pngegg.png",
      "name": "Zinger Burger",
      "rate": "4.9",
      "rating": "124",
      "price": "12.5",
      "description": "Best Burger on the town,Try and let us know how it taste"
    },
    {
      "image": "assets/img/pngegg.png",
      "name": "Zinger Burger",
      "rate": "4.9",
      "rating": "124",
      "price": "12.5",
      "description": "Best Burger on the town,Try and let us know how it taste"
    },
    {
      "image": "assets/img/pngegg.png",
      "name": "Zinger Burger",
      "rate": "4.9",
      "rating": "124",
      "price": "12.5",
      "description": "Best Burger on the town,Try and let us know how it taste"
    },
  ];
  List pastaArr = [
    {
      "image": "assets/img/m_res_1.png",
      "name": "Zinger Burger",
      "rate": "4.9",
      "rating": "124",
      "price": "9.5",
      "description": "Best Burger on the town,Try and let us know how it taste"
    },
    {
      "image": "assets/img/m_res_1.png",
      "name": "Zinger Burger",
      "rate": "4.9",
      "rating": "124",
      "price": "9.5",
      "description": "Best Burger on the town,Try and let us know how it taste"
    }
  ];
  List pizzaArr = [
    {
      "image": "assets/img/m_res_2.png",
      "name": "Zinger Burger",
      "rate": "4.9",
      "rating": "124",
      "price": "15.5",
      "description": "Best Burger on the town,Try and let us know how it taste"
    },
    {
      "image": "assets/img/m_res_2.png",
      "name": "Zinger Burger",
      "rate": "4.9",
      "rating": "124",
      "price": "15.5",
      "description": "Best Burger on the town,Try and let us know how it taste"
    },
    {
      "image": "assets/img/m_res_2.png",
      "name": "Zinger Burger",
      "rate": "4.9",
      "rating": "124",
      "price": "15.5",
      "description": "Best Burger on the town,Try and let us know how it taste"
    },
  ];
  List mostPopArr = [
    {
      "image": "assets/img/m_res_1.png",
      "name": "Minute by tuk tuk",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/m_res_2.png",
      "name": "Café de Noir",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/m_res_1.png",
      "name": "Minute by tuk tuk",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/m_res_2.png",
      "name": "Café de Noir",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
  ];



  @override
  Widget build(BuildContext context) {
    List currentList = burgerArr;
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 180),
            width: media.width * 0.27,
            height: media.height * 0.6,
            decoration: BoxDecoration(
              color: TColor.primary,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 46,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Menu",
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyOrderView(),
                              ),
                            );
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
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RoundTextfield(
                      hintText: "Search Food",
                      controller: txtSearch,
                      left: Container(
                        alignment: Alignment.center,
                        width: 30,
                        child: Image.asset(
                          "assets/img/search.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemCount: catArr.length,
                      itemBuilder: (context, index) {
                        var cObj = catArr[index] as Map? ?? {};
                        return CategoryCell(
                          cObj: cObj,
                          onTap: () {},
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ViewAllTitleRow(
                      title: "New Offers",
                      onView: () {},
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemCount: mostPopArr.length,
                      itemBuilder: ((context, index) {
                        var mObj = mostPopArr[index] as Map? ?? {};
                        return MostPopularCell(
                          mObj: mObj,
                          onTap: () {},
                        );
                      }),
                    ),
                  ),
                  // Buttons for Burger, Pizza, Pasta
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentList = burgerArr;
                          });
                        },
                        child: Text("Burger"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentList = pizzaArr;
                          });
                        },
                        child: Text("Pizza"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentList = pastaArr;
                          });
                        },
                        child: Text("Pasta"),
                      ),
                    ],
                  ),
                  // List of items from the selected list
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: currentList.length,
                    itemBuilder: ((context, index) {
                      var mObj = currentList[index] as Map? ?? {};
                      return MenuCardColumn(
                        pObj: mObj,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ItemDetailsView(),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
