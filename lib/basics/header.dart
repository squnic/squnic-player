import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'colors.dart';

class WaveHeader extends StatelessWidget {
  final String text;
  final int count;
  const WaveHeader({Key key, @required this.text, @required this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Stack(
        children: <Widget>[
          Container(
            child: Image.asset('assets/home/waves.png',fit:BoxFit.cover),
          ),
          Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 60,
                ),
                Text(
                  text,
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.white,
                      fontSize: 25),
                ),
                Text(
                  count.toString(),
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.white,
                      fontSize: 15),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
