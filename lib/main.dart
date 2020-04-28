import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:flutter_multimedia_picker/data/MediaFile.dart';
import 'package:permission_handler/permission_handler.dart';

import './basics/colors.dart';
import './basics/innerglow.dart';

import './video/allfileswidget.dart';
import './video/folderpagewidget.dart';
import './video/functions.dart';

Color foldersTabColor = ThemeColors.green;
Color allFilesTabColor = ThemeColors.white;

void main() => runApp(MaterialApp(
      title: "App",
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static PageController _pageController = PageController();
  static double currentPageValue = 0.0;
  static int navigationTracker = 0;
  static int navigationConstant = 0;

  static int count = 0;
  static List<MediaFile> videoList = [];
  static List<Map<dynamic, dynamic>> foldersList = [];
  static int folderCount = 0;

  static List<MediaFile> sortedByRecentVideo = [];
  static List<Uint8List> recentThumbnail = [];

  @override
  void initState() {
    super.initState();

    _checkPermission().then((granted) {
      if (!granted) return;
    });

    VideoFunctions.getVideosList().then((videos) {
      videoList = videos;
      count = videoList.length;
      sortedByRecentVideo = videos;
      sortedByRecentVideo.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
      // print(sortedByRecentVideo[0].thumbnailPath);
      // print(sortedByRecentVideo[200].dateAdded);
      // for(int i=0;i<5;i++){
      //   VideoFunctions.getVideoThumbnail(sortedByRecentVideo[i].path).then((thumb){
      //     recentThumbnail.add(thumb);
      //   });
      // }
      print(sortedByRecentVideo[0].thumbnailPath);
    });
    VideoFunctions.getFolderList().then((list) {
      setState(() {
        foldersList = list;
        folderCount = foldersList.length;
      });
    });

    _pageController.addListener(() {
      setState(() {
        currentPageValue = _pageController.page;
        if (currentPageValue == 1.0) {
          navigationTracker = navigationConstant;
        } else if (currentPageValue == 0.0) {
          navigationTracker = 0;
        } else {
          navigationTracker = (navigationConstant * currentPageValue).ceil();
        }
      });
    });
  }

  Future<bool> _checkPermission() async {
    final permissionStorageGroup =
        Platform.isIOS ? Permission.photos : Permission.storage;
    Map<Permission, PermissionStatus> res = await [
      Permission.photos,
      Permission.storage,
      permissionStorageGroup,
    ].request();
    return res[permissionStorageGroup] == PermissionStatus.granted;
  }

  Widget folderPageWidget() {
    return FolderPageWidget(
      folderCount: folderCount,
      foldersList: foldersList,
      sortedByRecentVideo: sortedByRecentVideo,
      recentThumbnail: recentThumbnail,
    );
  }

  Widget allFilesWidget() {
    return AllFilesWidget(
      videoList: videoList,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ThemeColors.background,
    ));
    navigationConstant = ((MediaQuery.of(context).size.width - 20) / 2).floor();
    return Scaffold(
        body: SafeArea(
            child: Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                  color: ThemeColors.background,
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                        child: Stack(children: <Widget>[
                      PageView.builder(
                          controller: _pageController,
                          itemCount: 2,
                          itemBuilder: (context, position) {
                            if (currentPageValue >= 0.5) {
                              allFilesTabColor = ThemeColors.selectedTabColor;
                              foldersTabColor = ThemeColors.white;
                            } else {
                              allFilesTabColor = ThemeColors.white;
                              foldersTabColor = ThemeColors.selectedTabColor;
                            }
                            if (position == currentPageValue.floor()) {
                              return Transform(
                                transform: Matrix4.identity()
                                  ..rotateX(currentPageValue - position),
                                child: position % 2 == 0
                                    ? folderPageWidget()
                                    : allFilesWidget(),
                              );
                            } else if (position ==
                                currentPageValue.floor() + 1) {
                              return Transform(
                                transform: Matrix4.identity()
                                  ..rotateX(currentPageValue - position),
                                child: position % 2 == 0
                                    ? folderPageWidget()
                                    : allFilesWidget(),
                              );
                            } else {
                              return position % 2 == 0
                                  ? folderPageWidget()
                                  : allFilesWidget();
                            }
                          }),
                      Container(
                          height: 60,
                          color: Colors.transparent,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Image.asset(
                                  'assets/3x/app_drawer.png',
                                ),
                              ),
                              Expanded(
                                  child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Image.asset(
                                    'assets/3x/search.png',
                                  ),
                                ),
                              )),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Image.asset(
                                  'assets/3x/menu.png',
                                ),
                              ),
                            ],
                          )),
                    ])),
                    Container(
                        height: 60,
                        alignment: Alignment.bottomCenter,
                        color: ThemeColors.background,
                        child: InnerGlowWidget(
                          horizontalMargin: 10,
                          verticalMargin: 10,
                          child: Stack(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: InkWell(
                                            onTap: () {
                                              if (_pageController.page == 1) {
                                                _pageController.animateToPage(0,
                                                    duration: Duration(
                                                        milliseconds: 500),
                                                    curve: Curves.linear);
                                              }
                                            },
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                "FOLDERS",
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.bold,
                                                    color: foldersTabColor),
                                              ),
                                            ))),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Image.asset(
                                          'assets/home/tab_splitter.png'),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: InkWell(
                                          onTap: () {
                                            if (_pageController.page == 0) {
                                              _pageController.animateToPage(1,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.linear);
                                            }
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "ALL FILES",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.bold,
                                                  color: allFilesTabColor),
                                            ),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                              Positioned(
                                  left: (MediaQuery.of(context).size.width /
                                          2) -
                                      10 - // Margin
                                      ((MediaQuery.of(context).size.width -
                                                  20) /
                                              2)
                                          .ceil() + // Size of the bar
                                      0 + // Distance between center and tabs
                                      0 + //  Placeholder => 2*45 = 90 + device width = *** => Next Tab
                                      navigationTracker,
                                  child: Container(
                                    width: ((MediaQuery.of(context).size.width -
                                            20) /
                                        2),
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: ThemeColors.green,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ))
                            ],
                          ),
                        )),
                  ],
                ))));
  }
}
