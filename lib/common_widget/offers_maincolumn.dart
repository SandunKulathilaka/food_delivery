import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class MainOffersCard extends StatelessWidget {
  final Map pObj;
  final VoidCallback onTap;
  const MainOffersCard({super.key, required this.pObj, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Image.network(
                pObj["image"],
                width: double.maxFinite,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(
              width: 8,
            ),

             const SizedBox(
              height: 12,
            ),

             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 20),
               child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          pObj["name"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                        InkWell(
                            child: Icon(Icons.add_shopping_cart,size: 20,color: Colors.deepOrange,),
                            onTap: (){
                              print(pObj["name"]);
                              print(pObj["description"]);
                              print(pObj["type"]);
                              print(pObj["valid"]);
                            },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Text(
                        "${pObj["description"]}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black, fontSize: 14),
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                        Text(
                          pObj["type"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: TColor.secondaryText, fontSize: 11),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              pObj["valid"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.deepOrange, fontSize: 14,fontWeight: FontWeight.bold,fontFamily: 'jokerman'),
                            ),
                            Text(
                              "Rs : ${pObj["price"]}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.deepOrange, fontSize: 18,fontWeight: FontWeight.bold,fontFamily: 'jokerman'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                  ],
                ),
             ),
            
          ],
        ),
      ),
    );
  }
}
