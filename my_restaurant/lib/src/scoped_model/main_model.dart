import 'package:myrestaurant/src/scoped_model/food_model.dart';
import 'package:myrestaurant/src/scoped_model/user_scoped_model.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model with FoodModel,UserModel{

}