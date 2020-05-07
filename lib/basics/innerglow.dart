import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'colors.dart';

class InnerGlowWidget extends StatelessWidget {
  InnerGlowWidget(
      {@required this.child,
      this.horizontalMargin = 0.0,
      this.verticalMargin = 0.0});
  final Widget child;
  final double horizontalMargin;
  final double verticalMargin;

  var colorTheme = ColorTheme();

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: horizontalMargin, vertical: verticalMargin),
        decoration: BoxDecoration(
            color: colorTheme.background,
            borderRadius: new BorderRadius.circular(5.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: colorTheme.innerBorder,
                blurRadius: 3,
                offset: Offset(0.0, 0.0),
                spreadRadius: 3,
              ),
            ]),
        // constraints: BoxConstraints.expand(),
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(
              borderRadius: new BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: colorTheme.white.withOpacity(0.06),
                  blurRadius: 10,
                ),
              ]),
          child: child,
        ));
  }
}
