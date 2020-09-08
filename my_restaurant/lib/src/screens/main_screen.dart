import 'package:flutter/material.dart';
import 'package:myrestaurant/src/admin/pages/add_food_item.dart';
import 'package:myrestaurant/src/pages/chat_page.dart';
import 'package:myrestaurant/src/scoped_model/main_model.dart';
import '../pages/home_page.dart';
import '../pages/order_page.dart';
import '../pages/explore_page.dart';
import '../pages/profile_page.dart';

class MainScreen extends StatefulWidget {
  final MainModel model;

  MainScreen({this.model});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTabIndex = 0;

  HomePage homePage;
  OrderPage orderPage;
  ProfilePage profilePage;
  FavoritePage favoritePage;

  List<Widget> pages;
  Widget currentPage;

  @override
  void initState() {
    homePage = HomePage(); // Pages
    favoritePage = FavoritePage(model: widget.model);
    orderPage = OrderPage();
    profilePage = ProfilePage();
    pages = [homePage, favoritePage, orderPage, profilePage];

    currentPage = homePage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            currentTabIndex == 0
                ? "Food Explorer Club"
                : currentTabIndex == 1
                    ? "Menü"
                    : currentTabIndex == 2 ? "Sepetim" : "Profil",
            style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: _buildNotifications(),
                onPressed: () {}),
            IconButton(
                icon: _buildShoppingCart(),
                onPressed: () {})
          ],
        ),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              Image(
                image: AssetImage("assets/icons/logo.png"),
                width: 150,
                height: 150,
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => AddFoodItem(),
                    ),
                  );
                },
                leading: Icon(Icons.list, color: Colors.blue,),
                title: Text(
                  "Yemek Ekle",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => Chat(),
                    ),
                  );
                },
                leading: Icon(Icons.call, color: Colors.blue,),
                title: Text(
                  "Destek Hattı",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (int index) {
            // Tab change function
            setState(() {
              currentTabIndex = index;
              currentPage = pages[index];
            });
          },
          currentIndex: currentTabIndex,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text("Ana Sayfa")),
            BottomNavigationBarItem(
                icon: Icon(Icons.explore), title: Text("Keşfet")),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), title: Text("Sepetim")),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text("Profil"))
          ],
        ),
        body: currentPage,
      ),
    );
  }

  Widget _buildShoppingCart(){
    return Stack(
      children: <Widget>[
        Icon(Icons.shopping_cart,
            color: Theme.of(context).primaryColor),
        Positioned(
          top: 0.0,
          right: 0.0,
          child: Container(
            height: 12.0,
            width: 12.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.5),
                color: Colors.red
            ),
            child: Center(
              child: Text("5", style: TextStyle(fontSize: 10.0, color: Colors.white),),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotifications(){
    return Stack(
      children: <Widget>[
        Icon(Icons.notifications_none,
            color: Theme.of(context).primaryColor),
        Positioned(
          top: 0.0,
          right: 0.0,
          child: Container(
            height: 12.0,
            width: 12.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.5),
                color: Colors.red
            ),
            child: Center(
              child: Text("2", style: TextStyle(fontSize: 10.0, color: Colors.white),),
            ),
          ),
        ),
      ],
    );
  }
}
