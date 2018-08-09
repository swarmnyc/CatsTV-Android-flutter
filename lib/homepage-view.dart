import 'package:flutter/material.dart';
import 'package:cga/video-item.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new Container(
        color: Colors.black,
        child: VideoItem(),
      ),
    );
  }
}
