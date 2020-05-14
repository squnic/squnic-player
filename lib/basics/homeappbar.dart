import 'package:flutter/material.dart';

class HomeAppBar extends StatefulWidget {
  HomeAppBar({Key key}) : super(key: key);

  @override
  _HomeAppBarState createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                                padding: EdgeInsets.only(
                                    right: 20, left: 10, top: 10, bottom: 10),
                                child: Image.asset(
                                  'assets/3x/menu.png',
                                ),
                              ),
                            ],
                          ));
  }
}