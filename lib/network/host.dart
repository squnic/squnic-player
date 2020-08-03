import 'dart:io';
import 'dart:convert' show utf8;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';
import 'package:angel_html/angel_html.dart';
import 'package:html_builder/elements.dart';
import 'package:angel_static/angel_static.dart';
import 'package:file/local.dart';
import 'package:flutter_multimedia_picker/data/MediaFile.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:wifi/wifi.dart';

import '../basics/colors.dart';
import '../basics/innerglow.dart';
import '../basics/functions.dart';
import '../video/functions.dart';

class NetworkHost extends StatelessWidget {
  const NetworkHost({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SafeArea(child: NetworkHostApp()));
  }
}

class NetworkHostApp extends StatefulWidget {
  NetworkHostApp({Key key}) : super(key: key);

  @override
  _NetworkHostAppState createState() => _NetworkHostAppState();
}

class _NetworkHostAppState extends State<NetworkHostApp> {
  int port = 3000;
  String ip = '';

  ColorTheme colorTheme = ColorTheme();
  double cardSize = 100.0;
  double userCardSize = 40.0;
  int userCount = 0;

  var selectHost = false;
  var files = false;
  var hostSelected = false;
  var hosted = false;

  var selectedFolder = '';
  var selectedVideo;

  HttpServer server;
  MediaFile videoFile;
  String videoPath = '';
  String videoName = '';
  Map<String, dynamic> json = {'path': '', 'name': ''};

  Uint8List bytes;

  int count = 0;
  List<MediaFile> videoList = [];
  List<MediaFile> folderFiles = [];
  List<Map<dynamic, dynamic>> foldersList = [];
  int folderCount = 0;

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

  @override
  void initState() {
    super.initState();
    _checkPermission().then((granted) {
      if (!granted) return;
      if (granted) {
        VideoFunctions.getVideosList().then((videos) {
          videoList = videos;
          count = videoList.length;
        });
        VideoFunctions.getFolderList().then((list) {
          setState(() {
            foldersList = list;
            folderCount = foldersList.length;
          });
        });
      }
    });
    // getVideoFile();
  }

  getVideoFile(value) async {
    videoFile = value;
    videoPath = videoFile.path;
    videoName = VideoFunctions.getFileNameFromPath(videoFile.path);
    // json={'path':videoPath,'name':videoName};
    json['path'] = videoFile.path;
    json['name'] = videoName;
    File(videoFile.path.toString())
        .readAsBytes()
        .then((value) => bytes = value);
    print('Video : $videoName');
  }

  getDeviceIp() {
    Wifi.ip.then((value) => ip = value);
    return 'http://' + ip.toString() + ':' + port.toString();
  }

  startServer() async {
    var app = Angel();
    var fs = const LocalFileSystem();
    var dirname = path.dirname(videoPath);
    app.fallback(renderHtml());
    app.get('/', (req, res) {
      return html(lang: 'en', c: [
        head(c: [
          meta(
              name: 'viewport', content: 'width=device-width, initial-scale=1'),
          title(c: [text('Test Player')]),
        ]),
        body(c: [
          h1(c: [
            text(videoName),
          ]),
          video(
            src: '/' + videoName,
            autoplay: true,
            controls: true,
          )
        ]),
      ]);
    });

    app.get('/name', (req, res) {
      res..write(videoName);
    });

    app.get('/not-found', (req, res) {
      return html(lang: 'en', c: [
        head(c: [
          meta(
              name: 'viewport', content: 'width=device-width, initial-scale=1'),
          title(c: [text('Test Player')]),
        ]),
        body(c: [
          h1(c: [
            text('Error 404 Page not found'),
          ]),
          p(c: [
            text('Return to '),
            a(c: [text('Home')], href: '/'),
          ]),
        ]),
      ]);
    });
    app.get('/' + videoName, (req, res) {
      return true;
    });
    app.fallback((req, res) {
      var urlPath = Uri.decodeFull(req.path);
      if (urlPath != videoName) return res.redirect('/not-found');
      return true;
    });
    print(videoName);
    print(dirname);
    var vDir = CachingVirtualDirectory(app, fs,
        allowDirectoryListing: true, source: fs.directory(dirname));
    app.fallback(vDir.handleRequest);

    var http = AngelHttp(app);
    server = await http.startServer('0.0.0.0', port);
    var url = 'http://${server.address.address}:${server.port}';
    print(url);
  }

  stopServer() async {
    setState(() {
      print('Server Stopped');
      server.close();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorTheme.background,
      appBar: AppBar(
        backgroundColor: colorTheme.background,
        leading: BackButton(color: colorTheme.def),
        title: Text('Host',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                color: colorTheme.def,
                fontSize: 20)),
      ),
      body: Container(
          constraints: BoxConstraints.expand(),
          margin: EdgeInsets.all(10),
          child: Stack(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  if (!hosted && !hostSelected) {
                                    setState(() {
                                      selectHost = true;
                                    });
                                  }
                                },
                                child: cardContainer('+'),
                              ),
                              hostSelected
                                  ? Expanded(
                                      child: Container(
                                        height: cardSize,
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(left: 10),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: colorTheme.primary,
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: Center(
                                                  child: Container(
                                                height: 20,
                                                child: Text(videoName,
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            colorTheme.primary,
                                                        fontSize: 15)),
                                              )),
                                            ),
                                            SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Container(
                                                  height: 20,
                                                  width: 65,
                                                  child: RaisedButton(
                                                      color: !hosted
                                                          ? colorTheme.primary
                                                          : Colors.redAccent,
                                                      elevation: 5,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          hosted = !hosted;
                                                        });
                                                        hosted
                                                            ? startServer()
                                                            : stopServer();
                                                      },
                                                      child: Text(
                                                          !hosted
                                                              ? 'Host'
                                                              : 'Stop',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: !hosted
                                                                  ? colorTheme
                                                                      .def
                                                                  : colorTheme
                                                                      .white,
                                                              fontSize: 10))),
                                                ),
                                                Container(
                                                  height: 20,
                                                  width: 65,
                                                  child: RaisedButton(
                                                      color: colorTheme.primary,
                                                      elevation: 5,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      onPressed: () {
                                                        if (hosted) {
                                                          stopServer();
                                                        }
                                                        setState(() {
                                                          hostSelected = false;
                                                          hosted = false;
                                                        });
                                                      },
                                                      child: Text('Cancel',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: colorTheme
                                                                  .def,
                                                              fontSize: 10))),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                        Expanded(
                          child: usersList(context),
                        )
                      ],
                    ),
                  ),
                  hosted
                      ? Padding(
                          padding: EdgeInsets.all(20),
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: FloatingActionButton(
                                onPressed: () {},
                                backgroundColor: colorTheme.primary,
                                child: Icon(Icons.play_arrow,
                                    color: colorTheme.white),
                              )))
                      : Container(),
                ],
              ),
              selectHost
                  ? Container(
                      decoration: BoxDecoration(
                        color: colorTheme.background,
                        border: Border.all(color: colorTheme.primary),
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                      constraints: BoxConstraints.expand(),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              files
                                  ? Container(
                                      margin:
                                          EdgeInsets.only(left: 20, top: 10),
                                      child: IconButton(
                                          icon: Icon(Icons.keyboard_backspace),
                                          color: colorTheme.primary,
                                          onPressed: () {
                                            setState(() {
                                              selectedFolder = '';
                                              files = false;
                                            });
                                          }),
                                    )
                                  : Container(),
                              Container(
                                margin: EdgeInsets.only(left: 20, top: 10),
                                child: Text(selectedFolder,
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold,
                                        color: colorTheme.primary,
                                        fontSize: 15)),
                              ),
                              Expanded(
                                  child: Container(
                                      height: 60,
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectHost = false;
                                              files = false;
                                              selectedFolder = '';
                                            });
                                          },
                                          child: Container(
                                              height: 40,
                                              width: 40,
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.only(
                                                  top: 10, right: 10),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.redAccent),
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        20.0),
                                              ),
                                              child: Text(
                                                'X',
                                                style: TextStyle(
                                                    color: Colors.redAccent),
                                              )))))
                            ],
                          ),
                          files ? hostFileSelect() : hostFolderSelect(),
                        ],
                      ))
                  : Container(),
            ],
          )),
    );
  }

  Widget cardContainer(String name) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 20),
        constraints: BoxConstraints.expand(width: cardSize, height: cardSize),
        decoration: BoxDecoration(
          border: Border.all(color: colorTheme.primary, width: 5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: InnerGlowWidget(
            child: Center(
          child: Text(name,
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: colorTheme.primary,
                  fontSize: 30)),
        )));
  }

  Widget usersList(context) {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, bottom: 50),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: colorTheme.primary, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
                (userCount == 0 ? 'No' : userCount.toString()) +
                    ' User' +
                    ((userCount == 0 || userCount == 1) ? '' : 's') +
                    ' Joined',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    color: colorTheme.def,
                    fontSize: 20)),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Divider(color: colorTheme.primary)),
          userCount == 0
              ? Expanded(
                  child: Center(
                    child: Text(
                        !hosted
                            ? 'Waiting for users to host ...'
                            : 'Web address : ' + getDeviceIp(),
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            color: colorTheme.def,
                            fontSize: 20)),
                  ),
                )
              : Expanded(
                  child: Container(
                  child: ListView.builder(
                    itemCount: userCount,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          ListTile(
                            leading: Container(
                              constraints: BoxConstraints.expand(
                                  width: userCardSize, height: userCardSize),
                              decoration: BoxDecoration(
                                color: colorTheme.def,
                                borderRadius:
                                    BorderRadius.circular(userCardSize),
                              ),
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 30),
                            title: Text('192.168.43.$index',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    color: colorTheme.def,
                                    fontSize: 15)),
                          ),
                          (index != (userCount - 1))
                              ? Padding(
                                  padding: EdgeInsets.only(right: 30, left: 80),
                                  child: Divider(color: colorTheme.primary))
                              : Container(),
                        ],
                      );
                    },
                  ),
                ))
        ],
      )),
    );
  }

  Widget hostFolderSelect() {
    var colorTheme = ColorTheme();
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(right: 5, top: 10, left: 5),
      child: GridView.count(
          physics: BouncingScrollPhysics(),
          crossAxisCount: 2,
          children: List.generate(folderCount, (i) {
            return GridTile(
              child: Padding(
                  padding: EdgeInsets.all(2),
                  child: InkWell(
                      onTap: () {
                        VideoFunctions.getFolderFiles(
                                foldersList[i]['path'].toString())
                            .then((videoList) {
                          folderFiles = videoList;
                        });
                        setState(() {
                          files = true;
                          selectedFolder = foldersList[i]['path']
                              .toString()
                              .split('/')[foldersList[i]['path']
                                  .toString()
                                  .split('/')
                                  .length -
                              2];
                        });
                      },
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
                                          ? foldersList[i]['name'].toString()
                                          : foldersList[i]['name']
                                                  .toString()
                                                  .substring(0, 10) +
                                              "...",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                          color: colorTheme.primary,
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                                Text(
                                  foldersList[i]['number'],
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                      color: colorTheme.primary,
                                      fontSize: 10),
                                ),
                              ],
                            ),
                          )))),
            );
          })),
    ));
  }

  Widget hostFileSelect() {
    var fileCount = folderFiles.length;
    return Expanded(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: fileCount,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              child: InkWell(
            onTap: () {
              setState(() {
                selectedVideo = folderFiles[index];
                hostSelected = true;
                selectHost = false;
              });
              getVideoFile(selectedVideo);
              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoPlayer(filePath: videoList[index].path,videoList: videoList,index: index,)));
            },
            child: InnerGlowWidget(
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
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    BasicFunctions.getFileNameWithoutExtension(
                                        folderFiles[index].path),
                                    style: TextStyle(
                                        color: colorTheme.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                )),
                            SizedBox(height: 10),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    BasicFunctions.msToTime(
                                        folderFiles[index].duration),
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
                                    folderFiles[index].path),
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
          ));
        },
      ),
    );
  }
}
