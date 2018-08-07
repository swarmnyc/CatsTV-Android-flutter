import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import 'package:flutter/widgets.dart';
import 'package:cga/api/data.dart';
import 'package:cga/widgets/main.dart';

class VideoItem extends StatefulWidget {
  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return _contentSection();
  }

  Timer _timer;
  List _mediaPosts;
  int currentIndex = 0;

  Animation<double> fadeAnimation;
  Animation<double> fadeAnimationWatermark;

  AnimationController controller;

  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(
        () {
          setState(() {});
        },
      );
    fadeAnimationWatermark = Tween(begin: 0.0, end: 0.5).animate(controller)
      ..addListener(
        () {
          setState(() {});
        },
      );
    controller.forward();
  }

  Widget _contentSection() {
    return new FutureBuilder(
      future: getMediaPosts(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (!snapshot.hasData) {
          return spinner();
        }

        _mediaPosts = snapshot.data;
        createMediaPostItem(_mediaPosts, context);

        if (currentIndex == gifURLS.length) {
          url = url.substring(0, url.lastIndexOf("after=")) +
              "after=$fetchedAfter";

          createMediaPostItem(_mediaPosts, context);

          while (currentIndex == gifURLS.length) {
            return spinner();
          }
        }

        return new Opacity(
          opacity: fadeAnimation.value,
          child: GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details) =>
                _onHorizontalDrag(details),
            child: new Container(
              child: new Stack(
                children: <Widget>[
                  _videoPlayer(gifURLS[currentIndex]),
                  _logoWatermark(),
                  // new Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: new Container(
                  //     color: Colors.white,
                  //     height: 100.0,
                  //     child: new Center(
                  //       child: Text(
                  //         'list length: ${gifURLS.length} \n current index: $currentIndex ',
                  //         style: TextStyle(
                  //             fontSize: 20.0, fontWeight: FontWeight.bold),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // video player using 'chewie' dependency
  Widget _videoPlayer(String _url) {
    getMoreData();
    return new Container(
      child: new Chewie(
        new VideoPlayerController.network('$_url'),
        autoInitialize: false,
        aspectRatio: 9 / 16,
        autoPlay: true,
        looping: true,
        showControls: false,
      ),
    );
  }

  void getMoreData() {
    if (gifURLS.length < 5 ||
        gifURLS.length < currentIndex * 2 ||
        currentIndex == gifURLS.length - 2) {
      url = url.substring(0, url.lastIndexOf("after=")) + "after=$fetchedAfter";

      createMediaPostItem(_mediaPosts, context);
    }
  }

  Widget _logoWatermark() {
    return new Align(
      alignment: Alignment.topRight,
      child: new Container(
        width: 100.0,
        height: 100.0,
        margin: EdgeInsets.only(
          top: 0.0,
          right: 20.0,
        ),
        child: Opacity(
          opacity: fadeAnimationWatermark.value,
          child: Image.asset('assets/images/Icon.png'),
        ),
      ),
    );
  }

// Horizontal drag gesture
// https://stackoverflow.com/a/51303072
  void _onHorizontalDrag(DragEndDetails details) {
    if (details.primaryVelocity == 0) return;

    // left swipe
    if (details.primaryVelocity.compareTo(0) == -1) {
      controller.reverse();
      setState(() {});

      _timer = new Timer(
        const Duration(milliseconds: 500),
        () {
          controller.forward();
          currentIndex++;
          setState(() {});
        },
      );
    }
    // right swipe
    else {
      if (!(currentIndex - 1 < 0)) {
        controller.reverse();
        setState(() {});

        _timer = new Timer(
          const Duration(milliseconds: 500),
          () {
            controller.forward();
            if (currentIndex - 1 != -1) {
              currentIndex--;
              setState(() {});
            }
          },
        );
      }
    }
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}
