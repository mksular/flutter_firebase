import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:the_validator/the_validator.dart';


class CreateUser extends StatefulWidget {
  final String title;
  CreateUser(this.title);

  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  var formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _email;
  String _sifre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text("Kayıt Ol | ${widget.title} ")),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onSaved: (x) {
                        setState(() {
                          _email = x;
                        });
                      },
                      autofocus: true,
                      validator: (x) {
                        if (x.isEmpty) {
                          return "Doldurulması Zorunludur!";
                        } else {
                          if (EmailValidator.validate(x) != true) {
                            return "Geçerli Bir Email Adresi Giriniz!";
                          } else {
                            return null;
                          }
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          errorStyle: TextStyle(fontSize: 18),
                          labelText: "Email",
                          labelStyle: TextStyle(fontSize: 20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.purple))),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      onSaved: (x) {
                        setState(() {
                          _sifre = x;
                        });
                      },
                      obscureText: true,
                      validator: FieldValidator.password(
                          minLength: 8,
                          shouldContainNumber: true,
                          shouldContainCapitalLetter: true,
                          shouldContainSpecialChars: true,
                          errorMessage:
                              "Minimum 8 Karakter uzunluğunda Olmalıdır!",
                          isNumberNotPresent: () {
                            return "Rakam İçermelidir!";
                          },
                          isSpecialCharsNotPresent: () {
                            return "Özel Karakter İçermelidir!";
                          },
                          isCapitalLetterNotPresent: () {
                            return "Büyük Harf İçermelidir!";
                          }),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          errorStyle: TextStyle(fontSize: 18),
                          labelText: "Şifre",
                          labelStyle: TextStyle(fontSize: 20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.purple))),
                    ),
                    SizedBox(height: 10),
                    RaisedButton.icon(
                      icon: Icon(
                        Icons.person_add,
                        color: Colors.white,
                      ),
                      onPressed: _emailSifreEkle,
                      color: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      hoverColor: Colors.black,
                      label: Text(
                        " Kayıt Ol",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                child: ListView(
                  children: <Widget>[
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.purple)),
                      child: ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, "/");
                        },
                        leading: Icon(
                          Icons.email,
                          color: Colors.red,
                        ),
                        title: Text(
                          "Email Giriş Yap",
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        ),
                        trailing: Icon(Icons.arrow_right,
                            size: 32, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _emailSifreEkle() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      var _firebaseUser = await _auth
          .createUserWithEmailAndPassword(email: _email, password: _sifre)
          .catchError((onError) => null);
      if (_firebaseUser != null) {
        Alert(
            type: AlertType.success,
            context: context,
            title: "KAYIT EKLENDİ!",
            desc: "Lütfen Email Adresinize Gelen Mesajı Onaylıyınız!",
            buttons: [
              DialogButton(
                child: Text(
                  "KAPAT",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ]).show();
        formKey.currentState.reset();

        _firebaseUser.user
            .sendEmailVerification()
            .then((value) => null)
            .catchError((onError) => null);
      } else {
        Alert(
            type: AlertType.warning,
            context: context,
            title: "KAYIT EKLENEMEDİ!",
            desc:
                "Sisteme Kayıtlı Bir Email Adresi Girdiniz. \n Lütfen Farklı Bir Email Adresi Giriniz!",
            buttons: [
              DialogButton(
                child: Text(
                  "KAPAT",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ]).show();
      }
    }
  }
}
