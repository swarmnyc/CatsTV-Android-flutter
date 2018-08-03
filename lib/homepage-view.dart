import 'package:flutter/material.dart';
import 'package:cga/video-item.dart';
import 'package:flutter/services.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // hide system overlay
    SystemChrome.setEnabledSystemUIOverlays([]);

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new Container(
        color: Colors.black,
        child: VideoItem(),
      ),
    );
  }
}
