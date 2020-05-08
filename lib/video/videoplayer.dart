import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_multimedia_picker/data/MediaFile.dart';

// import 'package:chewie/chewie.dart';
// import 'package:chewie/src/chewie_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound_player.dart';
import 'package:video_player/video_player.dart';
// import 'package:audio_service/audio_service.dart';
// import 'package:audio_focus/audio_focus.dart';

import '../basics/colors.dart';
import '../basics/innerglow.dart';
import '../basics/header.dart';
import '../basics/functions.dart';

import '../video/folderfiles.dart';
import '../video/functions.dart';

import '../video/chewie.dart';
import '../video/chewie/videocontrols.dart';

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

  // FlutterSoundPlayer flutterSoundPlayer;
  // AudioFocus audioFocus;

  bool showPlayerAppBar=true;

  // Future<int> audioFocus() async {
  //   flutterSoundPlayer = await FlutterSoundPlayer().initialize();
  //   if (Platform.isIOS)
	// 	await flutterSoundPlayer.iosSetCategory( t_IOS_SESSION_CATEGORY.PLAY_AND_RECORD, t_IOS_SESSION_MODE.DEFAULT, IOS_DEFAULT_TO_SPEAKER );
	// else if (Platform.isAndroid)
	// 	await flutterSoundPlayer.androidAudioFocusRequest( ANDROID_AUDIOFOCUS_GAIN );

  //   return 1;
  // }

  @override
  void initState() {
    super.initState();

    // audioFocus().then((value) => flutterSoundPlayer.setActive(true));
    // audioFocus = AudioFocus();
    // audioFocus;
    

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
      customControls: CustomControls(title:BasicFunctions.getFileNameWithoutExtension(widget.filePath)),

      // deviceOrientationsAfterFullScreen:[DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight],
      // overlay: showPlayerAppBar?playerAppBar():Container(),
    );
    
  }

  @override
  void dispose() {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _controller.dispose();
    _chewieController.dispose();

    // flutterSoundPlayer.setActive(false);

    super.dispose();
  }
  Widget videoPlayer(){
    // AudioService.play();
    // AudioServiceBackground.setState(controls: null, basicState: BasicPlaybackState.playing);
    // _controller.addListener(() {
    //   if(_chewieController.isFullScreen==false){
    //     _chewieController.enterFullScreen();
    //   }else{
    //     _chewieController.exitFullScreen();
    //   }
    // });
    return WillPopScope(child: Scaffold(
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
            child: Center(
              child: Chewie(
                controller: _chewieController,
              ),
            ),
          ),
          // playerAppBar(),
        ],
      )
          )),
    ), onWillPop: (){
      if(_chewieController.videoPlayerController.value.isPlaying){
        _chewieController.videoPlayerController.pause();
      }
      return Future.value(true);
    });
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
    return videoPlayer();
  }
}
