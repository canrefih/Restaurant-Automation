import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Material(
        elevation: 5.0, // holds on air the searchbox
        borderRadius: BorderRadius.circular(30.0),
        child: TextField(
          decoration: InputDecoration(
              hintText: "Yemek ara..",
              suffixIcon: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.black,
                  )),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 32.0, vertical: 14.0)),
        ),
      ),
    );
  }
}
