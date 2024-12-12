import 'package:flutter/material.dart';
import '../common/color_extension.dart';

class MenuCard extends StatelessWidget {
  final Map items;
  final VoidCallback onTap;

  const MenuCard({
    Key? key,
    required this.items,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two items per row
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (BuildContext context, int index) {
        final mObj = items[index];
        return InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  mObj["image"].toString(),
                  width: 220,
                  height: 130,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                mObj["name"],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    mObj["type"],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    " . ",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: TColor.primary, fontSize: 12),
                  ),
                  Text(
                    mObj["food_type"],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    "assets/img/rate.png",
                    width: 10,
                    height: 10,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    mObj["rate"],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: TColor.primary, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
