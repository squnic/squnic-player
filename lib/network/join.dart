import 'dart:convert' show utf8;
import 'package:flutter/material.dart';

import 'package:wifi/wifi.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:http/http.dart' as http;

import '../basics/colors.dart';
import '../video/videoplayer.dart';

class NetworkJoin extends StatelessWidget {
  const NetworkJoin({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SafeArea(child: NetworkJoinApp()));
  }
}

class NetworkJoinApp extends StatefulWidget {
  NetworkJoinApp({Key key}) : super(key: key);

  @override
  _NetworkJoinAppState createState() => _NetworkJoinAppState();
}

class _NetworkJoinAppState extends State<NetworkJoinApp> {
  ColorTheme colorTheme = ColorTheme();
  double cardSize = 100.0;
  double userCardSize = 40.0;
  int userCount = 0;
  var hosts = [];
  static const port = 3000;
  int selectedHost = -1;
  String videoName = '';

  @override
  void initState() {
    super.initState();
    getHosts();
  }

  getHosts() async {
    String ip = await Wifi.ip;
    String subnet = ip.substring(0, ip.lastIndexOf('.'));
    final stream = NetworkAnalyzer.discover2(subnet, port);
    setState(() {
      hosts = [];
      userCount = 0;
    });
    stream.listen((NetworkAddress addr) {
      if (addr.exists) {
        setState(() {
          hosts.add(addr.ip);
          userCount += 1;
        });
        print('Found device: ${addr.ip}');
      }
    });
  }

  getVideoName() async {
    var res;
    try {
      res = await http.get(
          'http://' + hosts[selectedHost] + ':' + port.toString() + '/name');
      setState(() {
        videoName = res.body;
      });
    } catch (ex) {
      print(ex);
      joinCancelled();
    }
  }

  joinCancelled() {
    setState(() {
      videoName = '';
      selectedHost = -1;
    });
  }

  getNetworkPath() {
    var url = 'http://' +
        hosts[selectedHost] +
        ':' +
        port.toString() +
        '/' +
        videoName.toString();
    // url = Uri.encodeFull(url);
    // print(url);
    return url;
  }

  printHosts() {
    print('No of Hosts ' + this.hosts.length.toString());
    for (var i = 0; i < this.hosts.length; i++) {
      print('Hosts ' + i.toString() + ' ' + this.hosts[i].toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorTheme.background,
      appBar: AppBar(
        backgroundColor: colorTheme.background,
        leading: BackButton(
          color: colorTheme.def,
          onPressed: () {
            // Navigator.of(context).pop();
          },
        ),
        title: Text('Join',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                color: colorTheme.def,
                fontSize: 20)),
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          Expanded(
            child: usersList(context),
          )
        ],
      )),
    );
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
                    ' Host' +
                    ((userCount == 0 || userCount == 1) ? '' : 's') +
                    ' Found',
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
                    child: Text('Waiting for users to host ...',
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
                            onTap: () {
                              setState(() {
                                selectedHost = index;
                              });
                              getVideoName();
                            },
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
                            title: Text(hosts[index],
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    color: colorTheme.def,
                                    fontSize: 15)),
                          ),
                          (index == selectedHost)
                              ? Container(
                                  height: cardSize,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(left: 10),
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: colorTheme.primary, width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: Center(
                                            child: Container(
                                          height: 20,
                                          child: Text(videoName,
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.bold,
                                                  color: colorTheme.primary,
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
                                                color: colorTheme.primary,
                                                elevation: 5,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              VideoPlayer(
                                                                filePath:
                                                                    getNetworkPath(),
                                                                isNetwork: true,
                                                              )));
                                                },
                                                child: Text('Play',
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: colorTheme.def,
                                                        fontSize: 10))),
                                          ),
                                          Container(
                                            height: 20,
                                            width: 65,
                                            child: RaisedButton(
                                                color: Colors.redAccent,
                                                elevation: 5,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                onPressed: () {
                                                  joinCancelled();
                                                },
                                                child: Text('Cancel',
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: colorTheme.white,
                                                        fontSize: 10))),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              : Container(),
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
}
