import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// loading spinner
Widget spinner() {
  return new Center(
    child: new Container(
        child: new CircularProgressIndicator(),
    ),
  );
}