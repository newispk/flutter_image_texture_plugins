
import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'flutter_image_texture.dart';

class FlutterImageTextureWidget extends StatefulWidget {

  final String url;

  const FlutterImageTextureWidget({Key key, this.url}) : super(key: key);

  @override
  _FlutterImageTextureWidgetState createState() => _FlutterImageTextureWidgetState();
}

class _FlutterImageTextureWidgetState extends State<FlutterImageTextureWidget>{

  int textureId;

  double width;

  double height;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImage();
  }

  Future loadImage() async{
    Map value = await FlutterImageTexture.loadImg(widget.url);
    textureId  = value['textureId'];
    width = value['width'];
    height = value['height'];
    print("hashCode----------$hashCode");
    if(mounted && width > 0 && height > 0)setState(() {});
  }

  @override
  void didUpdateWidget(covariant FlutterImageTextureWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(oldWidget.url!=widget.url){
      loadImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    
    if(textureId == null){
      return Container(
        color: Colors.white,
      );
    }
    return Container(
      width: width,
      height: height,
      child:Texture(textureId: textureId),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if(textureId!=null){
      FlutterImageTexture.release(textureId?.toString());
    }
    super.dispose();
  }
}
