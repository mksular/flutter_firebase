import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:loading_overlay/loading_overlay.dart';

class HomePage extends StatefulWidget {
  final String title;
  HomePage(this.title);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _email;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            RaisedButton.icon(
              label: Text(
                "Çıkış Yap",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.purple,
              icon: Icon(
                Icons.exit_to_app,
                size: 32,
                color: Colors.white,
              ),
              onPressed: _userCikis,
            )
          ],
        ),
        body: Center(
            child: Text(
          "Hoşgeldiniz! \n $_email",
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        )),
      ),
    );
  }

  void _currentUser() async {
    await _auth.currentUser().then((user) {
      setState(() {
        _email = user.email;
      });
    });
    setState(() {
      _isLoading=false;
    });
  }

  void _userCikis() async {
    await _auth
        .signOut()
        .then((value) => Navigator.pushNamed(context, "/"))
        .catchError((onError) {
      Alert(
          type: AlertType.warning,
          context: context,
          title: "ÇIKIŞ YAPILAMADI!",
          buttons: [
            DialogButton(
              child: Text(
                "KAPAT",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ]).show();
    });
  }
}
