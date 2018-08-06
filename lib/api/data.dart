import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

String fetchedAfter;
var gifURLS = [];
// json page limit
int limit = 10;
String after = '';

String redditURL =
    'https://www.reddit.com/r/catgifs/hot.json?limit=$limit&after=';
String url = 'https://www.reddit.com/r/catgifs/hot.json?limit=$limit&after=';

class MediaPost {
  String urlPath;
  String domain;
  String thumbnail;
  String pathURL;

  MediaPost(this.urlPath, this.domain, this.thumbnail, this.pathURL);
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
      fetchedAfter = data['data']['after'];
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
    String pathURL = data[i]["data"]['secure_media'];

    MediaPost mediaPost = new MediaPost(urlPath, domain, thumbnail, pathURL);

    list.add(mediaPost);
  }
  return list;
}

// Parse media content
void createMediaPostCardItem(
    List<MediaPost> _mediaPosts, BuildContext context) {
  String parsedUrlWebm = '';
  String parsedUrlGifv = '';
  if (_mediaPosts != null) {
    MediaPost mediaPost = _mediaPosts[0];
    for (var i = 0; i < _mediaPosts.length; i++) {
      mediaPost = _mediaPosts[i];

      // if (mediaPost.domain == 'v.redd.it') {
      //   print('MEDIA PATH URL');

      // }

      // gifv
      if (mediaPost.urlPath.endsWith(".gifv") ||
          mediaPost.urlPath.endsWith(".gif")) {
        parsedUrlGifv =
            mediaPost.urlPath.substring(0, mediaPost.urlPath.lastIndexOf(".")) +
                ".mp4";
        if (!(gifURLS.contains(parsedUrlGifv)) &&
            mediaPost.thumbnail != 'nsfw') {
          gifURLS.add(parsedUrlGifv);
        }
      }

      // //GfyCat / webm urls
      // if (mediaPost.domain == 'gfycat.com') {
      //   parsedUrlWebm = mediaPost.urlPath;
      //   parsedUrlWebm = parsedUrlWebm.replaceAll('gfycat', 'giant.gfycat');
      //   parsedUrlWebm = parsedUrlWebm + '.webm';
      //   if (!(gifURLS.contains(parsedUrlWebm)) &&
      //       mediaPost.thumbnail != 'nsfw') {
      //     gifURLS.add(parsedUrlWebm);
      //   }
      // }
    }
  }
  print(gifURLS);
}
