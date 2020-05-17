import 'package:flutter/material.dart';

import 'videos.dart';
import 'network.dart';

// Color foldersTabColor = ThemeColors.green;
// Color allFilesTabColor = ThemeColors.white;

void main(){
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
  runApp(MaterialApp(
      title: "App",
      home: MyApp(),
    ));
}

// void main(){
//   // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
//   runApp(MaterialApp(
//       title: "App",
//       home: NetworkHome(),
//     ));
// }