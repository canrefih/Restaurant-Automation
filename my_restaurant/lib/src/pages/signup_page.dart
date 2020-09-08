import 'package:flutter/material.dart';
import 'package:myrestaurant/src/enums/auth-model.dart';
import 'package:myrestaurant/src/pages/signin_page.dart';
import 'package:myrestaurant/src/scoped_model/main_model.dart';
import 'package:myrestaurant/src/widgets/show_dialog.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _toggleVisibility = true;

  String _email;
  String _username;
  String _password;

  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Email Adresiniz",
        hintStyle: TextStyle(
          color: Color(0XFFBDC2CB),
          fontSize: 18.0,
        ),
      ),
      onSaved: (String email) {
        _email = email;
      },
      validator: (String email) {
        String errorMessage;
        if (!email.contains("@")) {
          errorMessage = "Email adresiniz geçersiz";
        }
        if (email.isEmpty) {
          errorMessage = "Email adresinizi girmeniz gerekli";
        }
        return errorMessage;
      },
    );
  }

  Widget _buildUsernameTextField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Kullanıcı Adınız",
        hintStyle: TextStyle(
          color: Color(0XFFBDC2CB),
          fontSize: 18.0,
        ),
      ),
      onSaved: (String username) {
        _username = username.trim();
      },
      validator: (String username) {
        String errorMessage;
        if (username.isEmpty) {
          errorMessage = "Kullanıcı adınızı boş bırakamazsınız.";
        }
        if (username.length < 5 || username.length > 18) {
          errorMessage =
              "Kullanıcı adınızı 5-18 karakter arasında oluşturunuz.";
        }
        return errorMessage;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Şifreniz",
        hintStyle: TextStyle(
          color: Color(0xFFBDC2CB),
          fontSize: 18.0,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            // when pressed the change icon changing visibility settings
            setState(() {
              _toggleVisibility = !_toggleVisibility;
            });
          },
          icon: _toggleVisibility
              ? Icon(Icons.visibility_off)
              : Icon(Icons.visibility), // icon changing
        ),
      ),
      obscureText: _toggleVisibility, // password hiding
      onSaved: (String password) {
        _password = password;
      },
      validator: (String password) {
        String errorMessage;
        if (password.isEmpty) {
          errorMessage = "Parolanızı girmeniz gerekli";
        }
        return errorMessage;
      },
    );
  }

  /* Widget _buildConfirmPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Şifre Tekrarı",
        hintStyle: TextStyle(
          color: Color(0xFFBDC2CB),
          fontSize: 18.0,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            // when pressed the change icon changing visibility settings
            setState(() {
              _toggleConfirmVisibility = !_toggleConfirmVisibility;
            });
          },
          icon: _toggleConfirmVisibility
              ? Icon(Icons.visibility_off)
              : Icon(Icons.visibility), // icon changing
        ),
      ),
      obscureText: _toggleConfirmVisibility, // password hiding
      onSaved: (String confirmPassword){
        _confirmPassword = confirmPassword;
      },
      validator: (String confirmPassword){
        String errorMessage;
        if(_password != confirmPassword){
          errorMessage = "Şifreler aynı olmalıdır";
        }
        return errorMessage;
      },
    );
  }

   */

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.grey.shade100,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage("assets/icons/logo.png"),
                  width: 230,
                  height: 185,
                ),
                Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        _buildUsernameTextField(),
                        SizedBox(height: 15.0),
                        _buildEmailTextField(),
                        SizedBox(height: 15.0),
                        _buildPasswordTextField(),
                        //SizedBox(height: 15.0),
                        //_buildConfirmPasswordTextField()
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                _buildSignUpButton(),
                Divider(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Zaten bir hesabınız var mı ?",
                      style: TextStyle(
                          color: Color(0xFFBDC2CB),
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                    SizedBox(width: 10.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => SignInPage()));
                      },
                      child: Text(
                        "Giriş Yap",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return ScopedModelDescendant(
      builder: (BuildContext sctx, Widget child, MainModel model) {
        return GestureDetector(
          onTap: () {
            showLoadingIndicator(context, "Kayıt Yapılıyor");
            onSubmit(model.authenticate);
          },
          child: Container(
            height: 50.0,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(25.0)),
            child: Center(
              child: Text(
                "Kayıt Ol",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }

  void onSubmit(Function authenticate) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      authenticate(_email, _password, _username, authMode: AuthMode.SignUp)
          .then((final response) {
        Navigator.of(context).pop();
        if (!response['hasError']) {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed("/mainscreen");
        } else {
          Navigator.of(context).pop();
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red,
              content: Text(response['message']),
            ),
          );
        }
      });
    }
  }
}
