import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

var gifUrls = [];
int limit = 20;
String after = '';

String url =
    'https://www.reddit.com/r/catgifs/hot.json?limit=$limit&after=$after';

class MediaPost {
  String urlPath;
  String domain;
  String thumbnail;

  MediaPost(this.urlPath, this.domain, this.thumbnail);
}

// Get data
// future - used to represent a potential value, or error,
// that will be avaialble in the future
Future<List<MediaPost>> getMediaPosts() async {
  var httpClient = new HttpClient();
  try {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var json = await response.transform(Utf8Decoder()).join();
      var data = jsonDecode(json);
      List results = data['data']['children'];
      after = data['data']['after'];
      List<MediaPost> mediaPostList = createMediaPostList(results);
      return mediaPostList;
    } else {
      print("Failed http call.");
    }
  } catch (exception) {
    print(exception.toString());
  }
  return null;
}

// Create List of Data
List<MediaPost> createMediaPostList(List data) {
  List<MediaPost> list = new List();
  for (int i = 0; i < data.length; i++) {
    String urlPath = data[i]["data"]['url'];
    String domain = data[i]["data"]['domain'];
    String thumbnail = data[i]["data"]['thumbnail'];

    MediaPost mediaPost = new MediaPost(urlPath, domain, thumbnail);

    list.add(mediaPost);
  }
  return list;
}

// Parse media content
void createMediaPostItem(List<MediaPost> _mediaPosts, BuildContext context) {
  // String parsedUrlWebm = '';
  String parsedUrlGifv = '';
  if (_mediaPosts != null) {
    MediaPost mediaPost = _mediaPosts[0];

    for (var i = 0; i < _mediaPosts.length; i++) {
      mediaPost = _mediaPosts[i];

      // gifv urls
      if (mediaPost.urlPath.endsWith(".gifv")) {
        parsedUrlGifv =
            mediaPost.urlPath.substring(0, mediaPost.urlPath.lastIndexOf(".")) +
                ".mp4";
        if (!(gifUrls.contains(parsedUrlGifv)) &&
            mediaPost.thumbnail != 'nsfw') {
          gifUrls.add(parsedUrlGifv);
        }
      }

      // //GfyCat / webm urls
      // if (mediaPost.domain == 'gfycat.com') {
      //   parsedUrlWebm = mediaPost.urlPath;
      //   parsedUrlWebm = parsedUrlWebm.replaceAll('gfycat', 'giant.gfycat');
      //   parsedUrlWebm = parsedUrlWebm + '.webm';
      //   if (!(gifUrls.contains(parsedUrlWebm)) &&
      //       mediaPost.thumbnail != 'nsfw') {
      //     gifUrls.add(parsedUrlWebm);
      //   }
      // }
    }
  }
}
