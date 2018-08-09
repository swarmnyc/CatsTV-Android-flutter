import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import 'package:flutter/widgets.dart';
import 'package:cga/data/reddit-data.dart';

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
  int _currentIndex = 0;

  Animation<double> fadeAnimation;
  Animation<double> fadeAnimationWatermark;

  AnimationController controller;

      VideoPlayerController _controller;


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
          return new Center(
            child: new CircularProgressIndicator(),
          );
        }

        _mediaPosts = snapshot.data;
        createMediaPostItem(_mediaPosts, context);

        if (_currentIndex == gifUrls.length) {
          url = url.substring(0, url.lastIndexOf("after=")) + "after=$after";

          createMediaPostItem(_mediaPosts, context);

          while (_currentIndex == gifUrls.length) {
            return new Center(
              child: new CircularProgressIndicator(),
            );
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
                  _videoPlayer(gifUrls[_currentIndex]),
                  _logoWatermark(),
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
    _controller = VideoPlayerController.network(
      '$_url',
    );
    _controller.setVolume(0.0);

    getMoreData();
    return new OrientationBuilder(
      builder: (context, orientation) {
        return new Container(
          child: new Chewie(
            _controller,
            autoInitialize: false,
            aspectRatio: orientation == Orientation.portrait ? 9 / 16 : 16 / 9,
            autoPlay: true,
            looping: true,
            showControls: false,
          ),
        );
      },
    );
  }

  void getMoreData() {
    if (gifUrls.length < 5 ||
        gifUrls.length < _currentIndex * 2 ||
        _currentIndex == gifUrls.length - 2) {
      url = url.substring(0, url.lastIndexOf("after=")) + "after=$after";

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
          _currentIndex++;
          setState(() {});
        },
      );
    }
    // right swipe
    else {
      if (!(_currentIndex - 1 < 0)) {
        controller.reverse();
        setState(() {});

        _timer = new Timer(
          const Duration(milliseconds: 500),
          () {
            controller.forward();
            if (_currentIndex - 1 != -1) {
              _currentIndex--;
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
