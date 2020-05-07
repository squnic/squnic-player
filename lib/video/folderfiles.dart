import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_multimedia_picker/data/MediaFile.dart';
import 'package:testplayer/video/allfileswidget.dart';

import '../basics/colors.dart';
import '../basics/innerglow.dart';
import '../basics/header.dart';

import '../video/functions.dart';

class FolderFiles extends StatefulWidget {
  final String folderPath;
  final List<MediaFile> videoList;
  FolderFiles({Key key, @required this.videoList, @required this.folderPath})
      : super(key: key);

  @override
  _FolderFilesState createState() => _FolderFilesState();
}

class _FolderFilesState extends State<FolderFiles> {
  var colorTheme = ColorTheme();
  String path;
  String folderName = "";

  @override
  void initState() {
    super.initState();

    path = this.widget.folderPath;
    folderName = path.split('/')[path.split('/').length - 2];
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    List<MediaFile> folderFiles = widget.videoList;

    return Scaffold(
        // appBar: AppBar(
        //   leading: BackButton(
        //     color: colorTheme.def,
        //   ),
        //   backgroundColor: colorTheme.background,
        // title: Text(
        //   folderName,
        //   style: TextStyle(
        //       fontFamily: 'Roboto',
        //       fontWeight: FontWeight.bold,
        //       color: colorTheme.def,
        //       fontSize: 20),
        // ),
        // ),
        body: SafeArea(
      child: Stack(
        children: <Widget>[
          AllFilesWidget(
            videoList: folderFiles,
            title: folderName,
          ),
          BackButton(
            color: colorTheme.def,
          ),
        ],
      ),
    ));
  }
}
