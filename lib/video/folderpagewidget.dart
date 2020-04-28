import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_multimedia_picker/data/MediaFile.dart';

import '../basics/colors.dart';
import '../basics/innerglow.dart';
import '../basics/header.dart';

class FolderPageWidget extends StatefulWidget {
  int folderCount = 0;
  List<Map<dynamic, dynamic>> foldersList = [];
  List<MediaFile> sortedByRecentVideo = [];
  List<Uint8List> recentThumbnail = [];

  FolderPageWidget(
      {Key key,
      @required this.folderCount,
      @required this.foldersList,
      @required this.sortedByRecentVideo,
      @required this.recentThumbnail})
      : super(key: key);

  @override
  _FolderPageWidgetState createState() => _FolderPageWidgetState();
}

class _FolderPageWidgetState extends State<FolderPageWidget> {
  static bool showRecentFiles = true;

  @override
  Widget build(BuildContext context) {
    int folderCount = widget.folderCount;
    List<Map<dynamic, dynamic>> foldersList = widget.foldersList;
    List<MediaFile> sortedByRecentVideo = widget.sortedByRecentVideo;
    int count = sortedByRecentVideo.length;
    List<Uint8List> recentThumbnail = widget.recentThumbnail;

    return Container(
        color: ThemeColors.background,
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  WaveHeader(text: 'Folders', count: folderCount),
                  InnerGlowWidget(
                      horizontalMargin: 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Recent Files',
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                          color: ThemeColors.white,
                                          fontSize: 17),
                                    ),
                                  ),
                                  Expanded(
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: IconButton(
                                            icon: Icon(
                                              showRecentFiles?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down,
                                            ),
                                            color: ThemeColors.white,
                                            onPressed: () {
                                              setState(() {
                                                showRecentFiles =
                                                    !showRecentFiles;
                                              });
                                            },
                                          )))
                                ],
                              )),
                          AnimatedContainer(
                                  height: showRecentFiles?70:0,
                                  margin: EdgeInsets.only(bottom: showRecentFiles?10:0),
                                  child: GridView.count(
                                      crossAxisCount: 5,
                                      children: List.generate(5, (i) {
                                        return GridTile(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Card(
                                                // child: Image.file(File(sortedByRecentVideo[i].path)),
                                                // child:Text("$i")
                                                // child: Image.memory(recentThumbnail[i].sublist(0)),
                                                ),
                                          ),
                                        );
                                      })),
                                  duration: Duration(milliseconds: 500),
                                ),
                        ],
                      ))
                ],
              ),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: GridView.count(
                  physics: BouncingScrollPhysics(),
                  crossAxisCount: 3,
                  children: List.generate(folderCount, (i) {
                    return GridTile(
                      child: Padding(
                          padding: EdgeInsets.all(2),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: Colors.transparent,
                              child: InnerGlowWidget(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: 60,
                                      height: 60,
                                      child: Image.asset(
                                        'assets/home/darkfolder.png',
                                        width: 60,
                                        height: 60,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 1),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          foldersList[i]['name']
                                                      .toString()
                                                      .length <=
                                                  13
                                              ? foldersList[i]['name']
                                                  .toString()
                                              : foldersList[i]['name']
                                                      .toString()
                                                      .substring(0, 10) +
                                                  "...",
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.bold,
                                              color: ThemeColors.textColor,
                                              fontSize: 13),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      foldersList[i]['number'],
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                          color: ThemeColors.textColor,
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                              ))),
                    );
                  })),
            ))
          ],
        ));
  }
}
