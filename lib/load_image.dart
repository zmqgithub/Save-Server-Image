import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ServerLocalImage extends StatefulWidget{
  String url;

  ServerLocalImage(this.url);

  @override
  _LoadImages createState() => new _LoadImages(url);
}

class _LoadImages extends State<ServerLocalImage>{

  String url;
  String filename;
  var dataBytes;

  _LoadImages(this.url){
    filename = Uri.parse(url).pathSegments.last;
    downloadImage().then((bytes){
      setState(() {
        dataBytes = bytes;
      });
    });
  }

  Future<dynamic> downloadImage() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');

    if (file.existsSync()) {
      print('file already exist');
      var image = await file.readAsBytes();
      return image;
    } else {
      print('file not found downloading from server');
      var request = await http.get(url,);
      var bytes = await request.bodyBytes;//close();
      await file.writeAsBytes(bytes);
      print(file.path);
      return bytes;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(dataBytes!=null)
    return new Image.memory(dataBytes);
    else return new CircularProgressIndicator();
  }
}