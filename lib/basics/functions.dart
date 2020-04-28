import 'dart:io';

import 'package:flutter/material.dart';

class BasicFunctions {
  static String msToTime(int duration) {
    var milliseconds = ((duration % 1000) / 100).round();
    var seconds = ((duration / 1000) % 60).round();
    var minutes = ((duration / (1000 * 60)) % 60).round();
    var hours = ((duration / (1000 * 60 * 60)) % 24).round();

    var hour = (hours < 10) ? "0" + hours.toString() : hours.toString();
    var minute = (minutes < 10) ? "0" + minutes.toString() : minutes.toString();
    var second = (seconds < 10) ? "0" + seconds.toString() : seconds.toString();

    return hour + ":" + minute + ":" + second;
  }

  static String getFileNameWithoutExtension(String filePath) {
    String fileName = filePath.split('/').last;
    String ext = fileName.split('.').last;
    return fileName.substring(0,fileName.length-ext.length-1);
  }

  static String getFileSizeFromPath(String path){
    File file = File(path);
    int size = file.lengthSync();
    int fileSize = size;
    String post="B";
    
    if(size>(1024*1024*1024)){
      fileSize=(size/(1024*1024*1024)).round();
      post = "GB";
    }else if(size>(1024*1024)){
      fileSize=(size/(1024*1024)).round();
      post = "MB";
    }else if(size>1024){
      fileSize=(size/1024).round();
      post = "KB";
    }
    
    return fileSize.toString()+" "+post;
  }
}
