import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './basics/homeappbar.dart';
import './basics/colors.dart';
import './basics/innerglow.dart';

import './network/host.dart';

class NetworkHome extends StatelessWidget {
  const NetworkHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserSelection(),
    );
  }
}

class UserSelection extends StatefulWidget {
  UserSelection({Key key}) : super(key: key);

  @override
  _UserSelectionState createState() => _UserSelectionState();
}

class _UserSelectionState extends State<UserSelection> {
  ColorTheme colorTheme;
  double cardSize = 150.0;

  @override
  void initState() {
    super.initState();
    colorTheme = ColorTheme();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: colorTheme.background,
    ));
    return Scaffold(
        body: SafeArea(
      child: Container(
        color: colorTheme.background,
        child: Stack(
          children: <Widget>[networkOptions(context), HomeAppBar()],
        ),
      ),
    ));
  }

  Widget networkOptions(context) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => NetworkHost()));
              },
              child: cardContainer('Host')),
          GestureDetector(onTap: () {}, child: cardContainer('Join')),
        ],
      ),
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
}
