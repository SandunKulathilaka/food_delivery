import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'checkout_view.dart';

class MyOrderView extends StatefulWidget {
  const MyOrderView({Key? key}) : super(key: key);

  @override
  State<MyOrderView> createState() => _MyOrderViewState();
}

class _MyOrderViewState extends State<MyOrderView> {
  List<Map<String, dynamic>> itemArr = [
    {"name": "Beef Burger", "qty": 1, "price": 16.0},
    {"name": "Classic Burger", "qty": 1, "price": 14.0},
    {"name": "Cheese Chicken Burger", "qty": 1, "price": 17.0},
    {"name": "Chicken Legs Basket", "qty": 2, "price": 15.0},
    {"name": "French Fries Large", "qty": 1, "price": 6.0}
  ];



  double getSubTotal() {
    return itemArr.fold(0, (previous, current) => previous + current['price'] * current['qty']);
  }

  void removeItem(int index) {
    setState(() {
      itemArr.removeAt(index);
    });
  }

  void increaseQuantity(int index) {
    setState(() {
      itemArr[index]['qty']++;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (itemArr[index]['qty'] > 1) {
        itemArr[index]['qty']--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
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
                      icon: Image.asset(
                        "assets/img/btn_back.png",
                        width: 20,
                        height: 20,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        "My Order",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: Row(
                  children: [
                    // Your shop logo and details
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(color: TColor.textfield),
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: itemArr.length,
                  separatorBuilder: ((context, index) => Divider(
                    indent: 25,
                    endIndent: 25,
                    color: TColor.secondaryText.withOpacity(0.5),
                    height: 1,
                  )),
                  itemBuilder: ((context, index) {
                    var cObj = itemArr[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    removeItem(index);
                                  },
                                  child: Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "${cObj["name"].toString()} x ${cObj["qty"].toString()}",
                                  style: TextStyle(
                                    color: TColor.primaryText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          GestureDetector(
                            onTap: () {
                              decreaseQuantity(index);
                            },
                            child: Icon(
                              Icons.remove_circle_outline,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 60,
                            child: Center(
                              child: Text(
                                "\$${(cObj["price"] * cObj["qty"]).toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              increaseQuantity(index);
                            },
                            child: Icon(
                              Icons.add_circle_outline,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Sub Total",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "\$${getSubTotal().toStringAsFixed(2)}",
                          style: TextStyle(
                            color: TColor.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Delivery Cost",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "\$2",
                          style: TextStyle(
                            color: TColor.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    Divider(
                      color: TColor.secondaryText.withOpacity(0.5),
                      height: 1,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "\$${(getSubTotal() + 2).toStringAsFixed(2)}",
                          style: TextStyle(
                            color: TColor.primary,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 25),
                    RoundButton(
                      title: "Checkout",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CheckoutView(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
