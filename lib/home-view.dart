import 'package:flutter/material.dart';
import 'package:cga/video-item.dart';
import 'package:flutter/services.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
  // hide statusbar
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

  return new Scaffold(
    body: new Container(
      color: Colors.black,
      child: VideoItem(),
    ),
  );
  }
}
