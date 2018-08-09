import 'package:flutter/material.dart';
import 'package:cga/homepage-view.dart';
import 'package:flutter/services.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // hide system overlay
    SystemChrome.setEnabledSystemUIOverlays([]);
    
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
