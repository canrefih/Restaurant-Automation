import 'package:flutter/material.dart';

class HomeTopInfo extends StatelessWidget {
  final textStyle = TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    // TODO: implement createState
    return Container(
      margin: EdgeInsets.only(
          bottom:
              20.0), // (only) you can define your which side you choose, (all) must be defined all of them
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, //space management of first columns elements
        crossAxisAlignment: CrossAxisAlignment
            .start, //space management of first columns elements
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment
                .start, //space management of first columns start
            children: <Widget>[
              Text("Bugün", style: textStyle),
              Text("ne yesem acaba?", style: textStyle)
            ],
          ),

        ],
      ),
    );
  }
}
