import 'package:flutter/material.dart';

class ThemeColors {
  static Color coolGrey = _colorFromHex('#616e7c');
  static Color darkGrey = _colorFromHex('#121212');
  static Color yellow1 = _colorFromHex('#ffd637');
  static Color yellow2 = _colorFromHex('#ffbb00');
  static Color orange = _colorFromHex('#ff8201');
  static Color white = _colorFromHex('#ffffff');
  static Color green = _colorFromHex('#03dac5');

  static Color background = _colorFromHex('#030d14');
  static Color innerGlow = _colorFromHex('#161616');
  static Color gaussianBlur = _colorFromHex('#272a2b');
  static Color innerBlack = _colorFromHex('#131c23');

  static Color selectedTabColor = _colorFromHex('#03dac5');
  static Color textColor = _colorFromHex('#03dac5');

  static Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
