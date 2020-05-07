import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_multimedia_picker/data/MediaFile.dart';

import 'package:chewie/chewie.dart';
import 'package:chewie/src/chewie_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../basics/colors.dart';
import '../basics/innerglow.dart';
import '../basics/header.dart';
import '../basics/functions.dart';

import '../video/folderfiles.dart';
import '../video/functions.dart';

class VideoPlayer extends StatefulWidget {
  final String filePath;
  final List<MediaFile> videoList;
  final int index;
  VideoPlayer(
      {Key key,
      @required this.filePath,
      @required this.videoList,
      @required this.index})
      : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  var colorTheme = ColorTheme();

  VideoPlayerController _controller;
  ChewieController _chewieController;
  File file;

  bool showPlayerAppBar=true;

  @override
  void initState() {
    super.initState();

    file = File(widget.filePath);
    _controller = VideoPlayerController.file(file);
    // _controller = new VideoPlayerController.network(
    //   'https://github.com/flutter/assets-for-api-docs/blob/master/assets/videos/butterfly.mp4?raw=true',
    // );
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      autoPlay: true,
      looping: false,
      showControls: true,
      allowFullScreen: true,
      allowedScreenSleep: false,
      fullScreenByDefault: false,
      
      // deviceOrientationsAfterFullScreen:[DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight],
      // overlay: showPlayerAppBar?playerAppBar():Container(),
    );
  }

  @override
  void dispose() {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Widget playerAppBar(){
    // Timer(Duration(seconds: 5), (){
    //   setState(() {
    //     showPlayerAppBar=false;
    //   });
    // });
    return Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                  child: Container(
                    color: colorTheme.background.withOpacity(showPlayerAppBar?0.4:0),
                child: Row(
                  children: <Widget>[
                    BackButton(
                      color: colorTheme.white,
                    ),
                    Text(
                      BasicFunctions.getFileNameWithoutExtension(
                          widget.filePath),
                      style: TextStyle(
                          color: colorTheme.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ],
                ),
              ))
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
    return Scaffold(
      body: SafeArea(
          child: GestureDetector(
            onTap: (){
              setState(() {
                showPlayerAppBar=!showPlayerAppBar;
              });
              print('tapped');
            },
            child:Stack(
        children: <Widget>[
          Container(
            color: colorTheme.background,
            child: Expanded(
              child: Chewie(
                controller: _chewieController,
              ),
            ),
          ),
          playerAppBar(),
        ],
      )
          )),
    );
  }
}
