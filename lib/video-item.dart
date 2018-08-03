import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

import 'package:flutter/widgets.dart';
import 'package:cga/api/data.dart';
import 'package:cga/widgets/main.dart';

class VideoItem extends StatefulWidget {
  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  @override
  Widget build(BuildContext context) {
    return _contentSection();
  }

  // video player using 'chewie' dependency
  Widget _playerWidget(String _url) {
    return Stack(
      children: <Widget>[
        spinner(),
        Center(
          child: new Chewie(
            new VideoPlayerController.network('$_url'),
            autoInitialize: true,
            aspectRatio: 9 / 16,
            autoPlay: true,
            looping: true,
            showControls: false,
          ),
        )
      ],
    );
  }

  Widget _contentSection() {
    return new FutureBuilder(
      future: getMediaPosts(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (!snapshot.hasData) {
          return new Container(
            child: spinner(),
          );
        }
        List mediaPosts = snapshot.data;
        createMediaPostCardItem(mediaPosts, context);
        return new GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) =>
              _onHorizontalDrag(details),
          child: new Container(
            child: new AnimatedOpacity(
              // start at 0.0
              opacity: 0.8,
              duration: Duration(milliseconds: 500),
              child: _playerWidget(gifURLS[currentIndex]),
            )
          )
        );
      }
    );
  }

// Parse media content
void createMediaPostCardItem(
  List<MediaPost> mediaPosts, BuildContext context) {
    if (mediaPosts != null) {
      MediaPost mediaPost = mediaPosts[0];
      for (var i = 0; i < mediaPosts.length; i++) {
        mediaPost = mediaPosts[i];
        var parsedURL =
            mediaPost.urlPath.substring(0, mediaPost.urlPath.lastIndexOf(".")) +
                ".mp4";
        if (!(gifURLS.contains(parsedURL)) &&
            mediaPost.urlPath.endsWith(".gifv") &&
            mediaPost.thumbnail != 'nsfw') {
          gifURLS.add(parsedURL);
        }
      }
    }
}

// Horizontal drag gesture
// https://stackoverflow.com/a/51303072
void _onHorizontalDrag(DragEndDetails details) {
  if (details.primaryVelocity == 0)
    return;

  if (details.primaryVelocity.compareTo(0) == -1) {
    setState(() {
      if (currentIndex == gifURLS.length - 1) {
        setState(() {
          after = fetchedAfter;
          url = '$redditURL$after';
        });
      } else {
        currentIndex++;
      }
    });
  } else {
    setState(() {
      if (currentIndex < 0) {
        setState(() {
          currentIndex = 0;
          return;
        });
      } else if (currentIndex >= 1) {
        currentIndex--;
      }
    });
  }
}
}
