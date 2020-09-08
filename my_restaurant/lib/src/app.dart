import 'package:flutter/material.dart';
import 'package:myrestaurant/src/pages/signin_page.dart';
import 'package:myrestaurant/src/scoped_model/main_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'screens/main_screen.dart';

class App extends StatelessWidget {
  final MainModel mainModel = MainModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: mainModel,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Food Explorer Club",
        theme: ThemeData(primaryColor: Colors.blueAccent),
        routes: {
          "/": (BuildContext context) => SignInPage(),
          "/mainscreen": (BuildContext context) => MainScreen(),
        },
        //home: AddFoodItem(),
      ),
    );
  }
}
