import 'package:flutter/material.dart';
import 'package:myrestaurant/src/pages/order_page.dart';

import 'small_button.dart';

class FoodItemCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;

  FoodItemCard(this.title, this.description, this.price);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width,
      height: 120.0,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
                blurRadius: 5.0, offset: Offset(0, 3), color: Colors.black12),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10.0),
            width: 90.0,
            height: 90.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/icons/kori_sauced_chicken.jpg",
                    ),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(10.0)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "$title",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 7.0),
              Container(
                width: 232,
                child: Text("$description"),
              ),
              SizedBox(height: 7.0),
              Container(
                width: 230,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "\u20BA $price",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => OrderPage()));
                      },
                      child: SmallButton(btnText: "Satın Al"),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
