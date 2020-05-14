import 'package:flutter/material.dart';

import '../basics/colors.dart';
import '../basics/innerglow.dart';

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
  ColorTheme colorTheme = ColorTheme();
  double cardSize = 100.0;
  double userCardSize = 40.0;
  int userCount = 0;

  bool hostSelected = false;
  bool hosted = false;

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
                              if (!hostSelected) {
                                setState(() {
                                  hostSelected = true;
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
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: colorTheme.primary, width: 2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Center(
                                          child: Text('Video File Name',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.bold,
                                                  color: colorTheme.primary,
                                                  fontSize: 15)),
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
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      hosted = !hosted;
                                                    });
                                                  },
                                                  child: Text(
                                                      !hosted ? 'Host' : 'Stop',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: !hosted
                                                              ? colorTheme.def
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
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      hostSelected = false;
                                                      hosted = false;
                                                    });
                                                  },
                                                  child: Text('Cancel',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: colorTheme.def,
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
                            child:
                                Icon(Icons.play_arrow, color: colorTheme.white),
                          )))
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
                    child: Text('Waiting for users to join ...',
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
}
