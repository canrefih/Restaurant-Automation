import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myrestaurant/src/models/food_model.dart';
import 'package:myrestaurant/src/scoped_model/main_model.dart';
import 'package:myrestaurant/src/widgets/button.dart';
import 'package:myrestaurant/src/widgets/show_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:image_picker/image_picker.dart';

class AddFoodItem extends StatefulWidget {
  final Food food;

  AddFoodItem({this.food});

  @override
  _AddFoodItemState createState() => _AddFoodItemState();
}

class _AddFoodItemState extends State<AddFoodItem> {
  String title;
  String category;
  String description;
  String price;
  String discount;

  GlobalKey<FormState> _foodItemFormKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey();

  File imageFile;

  _openGallery(BuildContext context) async{
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState((){
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async{
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState((){
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Resim Yükle"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text("Galeri"),
                onTap: (){
                  _openGallery(context);
                },
              ),
              Padding(padding: EdgeInsets.all(8.0),),
              GestureDetector(
                child: Text("Kamera"),
                onTap: (){
                  _openCamera(context);
                },
              )
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: (){
          Navigator.of(context).pop(false);
          return Future.value(false);
        },
        child: Scaffold(
          key: _scaffoldStateKey,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            title: Text(
                widget.food != null ? "Yemek Güncelleme" : "Yemek Ekleme",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold)),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add_a_photo),
                color: Colors.black,
                onPressed: (){
                  _showChoiceDialog(context);
                },
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              //width: MediaQuery.of(context).size.width,
              //height: MediaQuery.of(context).size.height,
              child: Form(
                key: _foodItemFormKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0,),
                    imageFile == null ? Text("Resim Yok") : Image.file(imageFile, width: 120, height: 120,),
                    /*IconButton(
                      onPressed: (){
                        _showChoiceDialog(context);
                      },
                      splashColor: Colors.cyan,
                      icon: Icon(
                        Icons.add_a_photo,
                      ),
                      iconSize: 120,
                    ),*/
                    /*RaisedButton(
                      child: _decideImageView(),
                      padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
                      splashColor: Colors.black54,
                      elevation: 20.0,
                      onPressed: (){
                        _showChoiceDialog(context);
                      },

                    ),*/
                    /*Container(
                      margin: EdgeInsets.only(bottom: 15.0),
                      width: MediaQuery.of(context).size.width,
                      height: 115.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: AssetImage("assets/icons/noimage.png"),
                        ),
                      ),
                    ), */
                    SizedBox(height: 20.0),
                    _buildTextFormField("Yemek Adı"),
                    _buildTextFormField("Kategori"),
                    _buildTextFormField("Açıklama", maxLine: 4),
                    _buildTextFormField(
                      "Fiyat",
                    ),
                    _buildTextFormField("İndirim"),
                    SizedBox(height: 40.0),
                    ScopedModelDescendant(
                      builder:
                          (BuildContext context, Widget child, MainModel model) {
                        return GestureDetector(
                          onTap: () {
                            onSubmit(model.addFood, model.updateFood);
                            if (model.isLoading) {
                              // show loading progress indicator
                              showLoadingIndicator(context, widget.food != null ? "Yemek Güncelleniyor.." : "Yemek Ekleniyor..");
                            }
                          },
                          child: Button(
                              btnText: widget.food != null
                                  ? "Yemeği Güncelle"
                                  : "Yemeği Ekle"),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSubmit(Function addFood, Function updateFood) async {
    if (_foodItemFormKey.currentState.validate()) {
      // if everything is validate it will save our datas
      _foodItemFormKey.currentState.save();

      if (widget.food != null) {
        // editing the food item
        Map<String, dynamic> updatedFoodItem = {
          "title": title,
          "category": category,
          "description": description,
          "price": double.parse(price),
          "discount": discount != null ? double.parse(discount) : 0.0,
        };

        final bool response = await updateFood(updatedFoodItem, widget.food.id);
        if(response){
          Navigator.of(context).pop(); // silme bildirimi
          Navigator.of(context).pop(response); // önceki sayfanın
        }else if(!response){
          Navigator.of(context).pop();
          SnackBar snackBar = SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
            content: Text("Güncelleme Sırasında Hata Oluştu.", style: TextStyle(color: Colors.white, fontSize: 16.0),),
          );
          _scaffoldStateKey.currentState.showSnackBar(snackBar);
        }
      } else if (widget.food == null) {
        // adding new item
        final Food food = Food(
          // adding to food_model.dart Food List
          name: title,
          category: category,
          description: description,
          price: double.parse(price),
          discount: double.parse(discount),
        );
        bool value = await addFood(food);
        if (value) {
          Navigator.of(context).pop();
          SnackBar snackBar = SnackBar(
            content: Text("Başarıyla Eklenmiştir."),
          );
          _scaffoldStateKey.currentState.showSnackBar(snackBar);
        } else if (!value) {
          Navigator.of(context).pop();
          SnackBar snackBar = SnackBar(
            content: Text("Eklenirken Hata Oluştu."),
          );
          _scaffoldStateKey.currentState.showSnackBar(snackBar);
        }
      }
    }
  }

  Widget _buildTextFormField(String hint, {int maxLine = 1}) {
    return TextFormField(
      initialValue: widget.food != null && hint == "Yemek Adı"
          ? widget.food.name
          : widget.food != null && hint == "Açıklama"
              ? widget.food.description
              : widget.food != null && hint == "Kategori"
                  ? widget.food.category
                  : widget.food != null && hint == "Fiyat"
                      ? widget.food.price.toString()
                      : widget.food != null && hint == "İndirim"
                          ? widget.food.discount.toString()
                          : "",
      decoration: InputDecoration(hintText: "$hint"),
      maxLines: maxLine,
      keyboardType: hint == "Fiyat" ||
              hint == "İndirim" // just price and description number keyboard
          ? TextInputType.number
          : TextInputType.text,
      validator: (String value) {
        if (value.isEmpty && hint == "Yemek Adı") {
          return "Yemek adını girmeniz gereklidir";
        }
        if (value.isEmpty && hint == "Kategori") {
          return "Kategoriyi girmeniz gereklidir";
        }
        if (value.isEmpty && hint == "Açıklama") {
          return "Açıklamayı girmeniz gereklidir";
        }
        if (value.isEmpty && hint == "Fiyat") {
          return "Yemeğin fiyatını girmeniz gereklidir";
        }
        //return "";
      },
      onSaved: (String value) {
        if (hint == "Yemek Adı") {
          title = value;
        }
        if (hint == "Kategori") {
          category = value;
        }
        if (hint == "Açıklama") {
          description = value;
        }
        if (hint == "Fiyat") {
          price = value;
        }
        if (hint == "İndirim") {
          discount = value;
        }
      },
    );
  }

  Widget _buildCategoryTextFormField() {
    return TextFormField();
  }
}
