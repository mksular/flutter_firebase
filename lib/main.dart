import 'package:flutter/material.dart';
import 'pages/homePage.dart';
import 'pages/createUser.dart';
import 'pages/loginUser.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
 
final  String title="Firebase Auth";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      initialRoute: "/",
      routes: {
        "/": (context) => LoginUser(title),
        "/createUser": (context) => CreateUser(title),
        "/homePage": (context) => HomePage(title),


      },
    );
  }
}
