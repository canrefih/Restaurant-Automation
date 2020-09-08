import 'package:myrestaurant/src/enums/auth-model.dart';
import 'package:myrestaurant/src/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserModel extends Model {
  List<User> _users = [];
  User _authenticatedUser;
  bool _isLoading = false;

  List<User> get users {
    return List.from(_users);
  }

  User get authenticatedUser {
    return _authenticatedUser;
  }

  bool get isLoading {
    return _isLoading;
  }

  Future<bool> addUserInfo(Map<String, dynamic> userInfo) async {
    // Map contains users email etc.
    _isLoading = true;
    notifyListeners();
    try {
      final http.Response response = await http.post(
          "https://food-explorer-club.firebaseio.com/users.json",
          body: json.encode(userInfo));
      final Map<String, dynamic> responseData = json.decode(response.body);

      //print(responseData["name"]);

      User userWithID = User(
        id: responseData['name'],
        email: userInfo['email'],
        username: userInfo['username'],
        /*firstName: userInfo['firstName'],
        lastName: userInfo['lastName'],
        phoneNumber: userInfo['phoneNumber'],
        token: userInfo['token'],
        userType: userInfo['userType'],*/
      );

      _users.add(userWithID);
      _isLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  Future<Map<String, dynamic>> authenticate(
      String email, String password, String username,
      {AuthMode authMode = AuthMode.SignIn}) async {
    _isLoading = true;
    notifyListeners();

    Map<String, dynamic> authData = {
      "email": email,
      "password": password,
      "returnSecureToken": true
    };

    Map<String, dynamic> userInfo = {
      "email": email,
      "username": username,
    };

    String message;
    bool hasError = false;

    try {
      http.Response response;
      if (authMode == AuthMode.SignUp) {
        response = await http.post(
            "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDeJHg8Rs3e4h-5KOXsMa8xUUkOJawmQoA",
            body: json.encode(authData),
            headers: {'Content-Type': 'application/json'});

        addUserInfo(userInfo);
      } else if (authMode == AuthMode.SignIn) {
        response = await http.post(
            "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDeJHg8Rs3e4h-5KOXsMa8xUUkOJawmQoA",
            body: json.encode(authData),
            headers: {'Content-Type': 'application/json'});
      }

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody.containsKey('idToken')) {
        _authenticatedUser = User(
            id: responseBody['localId'],
            email: responseBody['email'],
            token: responseBody['idToken'],);

        if (authMode == AuthMode.SignUp) {
          message = "Kayıt başarıyla yapıldı.";
        } else {
          message = "Giriş başarıyla yapıldı.";
        }
      } else {
        hasError = true;
        if (responseBody['error']['message'] == 'EMAIL_EXISTS') {
          message = 'Email adresinize kayıtlı bir kullanıcı var';
        } else if (responseBody['error']['message'] == "EMAIL_NOT_FOUND") {
          message = "Emaili kayıtlı bir hesap bulunamamıştır";
        } else if (responseBody['error']['message'] == "INVALID_PASSWORD") {
          message = "Şifreniz hatalıdır";
        }
      }

      _isLoading = false;
      notifyListeners();
      return {'message': message, 'hasError': hasError};
    } catch (error) {
      _isLoading = false;
      notifyListeners();

      return {'message': 'Kayıt yapılırken hata oluştu', 'hasError': !hasError};
    }
  }
}
