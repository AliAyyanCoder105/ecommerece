import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:untitled3/practice.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
   title: 'its time to comeback after an year',
      home: login(),
    );
  }
}
class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
body: Padding(padding: EdgeInsets.symmetric(horizontal: 25),
child: Center(
  child: Column(
    mainAxisSize: MainAxisSize.min,
children: [
Icon(Icons.lock),
  SizedBox(height: 20,),
  Text("Welcome back",
    style: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
  ),
  SizedBox(height: 20,),
  Text("Login to your account",
  style: TextStyle(
    color: Colors.grey,
  )
  ),
 SizedBox(height: 30,),
  TextField(
    decoration: InputDecoration(
      hintText: "Email",
      border: OutlineInputBorder(),
    ),
  )
],
  ),
),
),
    );
  }
}

