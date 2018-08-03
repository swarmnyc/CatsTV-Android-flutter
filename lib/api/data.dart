import 'dart:async';
import 'dart:convert';
import 'dart:io';

String fetchedAfter;
var gifURLS = [];
int currentIndex = 0;
// json page limit
int limit = 100;
String after = '';

String redditURL = 'https://www.reddit.com/r/gifs/hot.json?limit=100&after=';
String url = 'https://www.reddit.com/r/gifs/hot.json?limit=100&after=';

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
  if (currentIndex == gifURLS.length - 1) {
    after = fetchedAfter;
    url = '$redditURL$after';
  }

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

