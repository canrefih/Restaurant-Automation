import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myrestaurant/src/pages/signin_page.dart';
import 'package:myrestaurant/src/widgets/custom_list_tile.dart';
import 'package:myrestaurant/src/widgets/small_button.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  bool turnOnNotifications = false;
  bool turnOnLocation = false;

  File _image;

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var img = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = img;
      });
    }

    Future uploadPic(BuildContext context) async {
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      setState(() {
        print("Profil Resminiz Yüklendi");
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Profil Resminiz Yüklendi')));
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 120.0,
                    width: 120.0,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(60.0),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 3.0,
                            offset: Offset(0, 4.0),
                            color: Colors.black38),
                      ],
                      /*image: DecorationImage(
                            image: AssetImage("assets/icons/pp.jpg"),
                            fit: BoxFit.cover)*/
                    ),
                    child: (_image != null)
                        ? Image.file(_image, fit: BoxFit.fill)
                        : Image.network(
                            "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/300px-No_image_available.svg.png",
                            fit: BoxFit.fill,
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.camera_enhance,
                        size: 30.0,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        getImage();
                      },
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Refih CAN",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "+905394234347",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      SmallButton(
                        btnText: "Düzenle",
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 30.0),
              Text(
                "Hesap",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20.0,
              ),
              Card(
                elevation: 3.0,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      CustomListTile(icon: Icons.location_on, text: "Konum"),
                      Divider(height: 10.0, color: Colors.grey),
                      CustomListTile(
                          icon: Icons.visibility, text: "Şifre İşlemleri"),
                      Divider(height: 10.0, color: Colors.grey),
                      CustomListTile(
                          icon: Icons.shopping_cart, text: "Siparişler"),
                      Divider(height: 10.0, color: Colors.grey),
                      CustomListTile(icon: Icons.payment, text: "Ödemeler"),
                      Divider(height: 10.0, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                "Bildirimler",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Card(
                elevation: 3.0,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Uygulama Bildirimleri",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          Switch(
                            value: turnOnNotifications,
                            onChanged: (bool value) {
                              setState(() {
                                turnOnNotifications = value;
                              });
                            },
                          )
                        ],
                      ),
                      Divider(height: 10.0, color: Colors.grey),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Konum Takibi",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          Switch(
                            value: turnOnLocation,
                            onChanged: (bool value) {
                              setState(() {
                                turnOnLocation = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Divider(height: 10.0, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                "Diğer",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Card(
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Dil Seçeneği",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          //SizedBox(height: 30.0,),
                          Divider(height: 30.0, color: Colors.grey),
                          Text(
                            "Para Birimi",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          //SizedBox(height: 10.0,),
                          Divider(height: 30.0, color: Colors.grey),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SignInPage()));
                            },
                            child: Text(
                              "Çıkış",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
