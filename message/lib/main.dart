import 'package:flutter/material.dart';

import 'home/home-screen.dart';
import 'firebase-messaging-receive/firebase-messaging-receive-mixin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> 
with FirebaseMessagingReceiveMixin 
{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}
