import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuCardColumn extends StatelessWidget {
  final Map pObj;
  final VoidCallback onTap;
  const MenuCardColumn({super.key, required this.pObj, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                // Determine the card width based on the available width
                double cardWidth = constraints.maxWidth > 430 ? 430 : constraints.maxWidth;

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    width: cardWidth,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: onTap,
                          child: Container(
                            alignment: Alignment.center,
                            child: Image.asset(
                              pObj['image'],
                              height: 200,
                              width: cardWidth * 0.5, // Adjust image width based on card width
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.black, // Set background color to black
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    pObj['name'],
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white, // Set font color to white
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    pObj['description'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white, // Set font color to white
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "\$${pObj['price']}",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.deepOrange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Icon(
                                          Icons.favorite_border,
                                          color: Colors.deepOrange,
                                          size: 26,
                                        ),
                                        InkWell(
                                          onTap: (){

                                          },
                                          child: Icon(
                                            CupertinoIcons.cart,
                                            color: Colors.deepOrange,
                                            size: 26,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

}
