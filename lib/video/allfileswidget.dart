import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:flutter_multimedia_picker/data/MediaFile.dart';

import '../basics/colors.dart';
import '../basics/innerglow.dart';
import '../basics/header.dart';
import '../basics/functions.dart';

import '../video/functions.dart';
import '../video/videoplayer.dart';

class AllFilesWidget extends StatefulWidget {
  final List<MediaFile> videoList;
  final String title;
  final int playingIndex;

  AllFilesWidget({Key key, @required this.videoList,@required this.title,this.playingIndex=-1}) : super(key: key);

  @override
  _AllFilesWidgetState createState() => _AllFilesWidgetState();
}

class _AllFilesWidgetState extends State<AllFilesWidget> {
  static int fileCount = 0;
  static List<MediaFile> videoList = [];

  var colorTheme = ColorTheme();

  @override
  void initState() {
    super.initState();

    videoList = widget.videoList;
    fileCount = videoList.length;
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.title;
    return Container(
      color: colorTheme.background,
      child: Column(
        children: <Widget>[
          title!=null?WaveHeader(
            text: title,
            count: fileCount,
          ):Container(),
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: fileCount,
              itemBuilder: (BuildContext context, int index) {
                if(index==widget.playingIndex){
                  return Container();
                }
                return Container(
                  child: InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoPlayer(filePath: videoList[index].path,videoList: videoList,index: index,)));
                    },
                    child:InnerGlowWidget(
                      horizontalMargin: 10,
                      verticalMargin: 5,
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    width: 70,
                                    height: 50,
                                    color: colorTheme.def,
                                  )),
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          BasicFunctions
                                              .getFileNameWithoutExtension(
                                                  videoList[index].path),
                                          style: TextStyle(
                                              color: colorTheme.primary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      )),
                                  SizedBox(height: 10),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          BasicFunctions.msToTime(
                                              videoList[index].duration),
                                          style: TextStyle(
                                              color: colorTheme.def,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                      )),
                                ],
                              )),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      BasicFunctions.getFileSizeFromPath(
                                          videoList[index].path),
                                      style: TextStyle(
                                          color: colorTheme.def,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ))),
                  )
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
