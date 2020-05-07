import 'package:flutter/material.dart';

Color _colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

String theme = "darkblue";
List<Map<String,dynamic>> themeList=[{"theme":"darkblue","class":DarkBlueThemeColors()}];
class ColorTheme {
  // static Color coolGrey = _colorFromHex('#616e7c');
  // static Color darkGrey = _colorFromHex('#121212');
  // static Color yellow1 = _colorFromHex('#ffd637');
  // static Color yellow2 = _colorFromHex('#ffbb00');
  // static Color orange = _colorFromHex('#ff8201');
  // static Color white = _colorFromHex('#ffffff');
  // static Color green = _colorFromHex('#03dac5');

  // static Color background = _colorFromHex('#030d14');
  // static Color innerGlow = _colorFromHex('#161616');
  // static Color gaussianBlur = _colorFromHex('#272a2b');
  // static Color innerBlack = _colorFromHex('#131c23');

  // static Color selectedTabColor = _colorFromHex('#03dac5');
  // static Color textColor = _colorFromHex('#03dac5');

  var colorTheme;

  Color def;
  Color primary;

  Color background;
  Color innerGlow;
  Color gaussianBlur;
  Color innerBorder;

  Color white = _colorFromHex('#ffffff');
  Color black = _colorFromHex('#000000');

  ColorTheme(){
    // colorTheme = DarkBlueThemeColors();
    for(int i=0;i<themeList.length;i++){
      if(theme==themeList[i]['theme']){
        colorTheme = themeList[i]['class'];
      }
    }
    this.def = colorTheme.def;
    this.primary = colorTheme.primary;

    this.background = colorTheme.background;
    this.innerGlow = colorTheme.innerGlow;
    this.gaussianBlur = colorTheme.gaussianBlur;
    this.innerBorder = colorTheme.innerBorder;
  }
  get getColorTheme{
    return this.colorTheme;
  }
}

class LightBlueThemeColors {
  Color def = _colorFromHex('#ffffff');
  Color primary = _colorFromHex('#03dac5');

  Color background = _colorFromHex('#030d14');
  Color innerGlow = _colorFromHex('#161616');
  Color gaussianBlur = _colorFromHex('#272a2b');
  Color innerBorder = _colorFromHex('#131c23');
}

class DarkBlueThemeColors {
  Color def = _colorFromHex('#ffffff');
  Color primary = _colorFromHex('#03dac5');

  Color background = _colorFromHex('#030d14');
  Color innerGlow = _colorFromHex('#161616');
  Color gaussianBlur = _colorFromHex('#272a2b');
  Color innerBorder = _colorFromHex('#131c23');
}
