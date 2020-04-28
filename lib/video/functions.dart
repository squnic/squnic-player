import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_multimedia_picker/fullter_multimedia_picker.dart';
import 'package:flutter_multimedia_picker/data/MediaFile.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoFunctions {
  static List<MediaFile> videoList = [];
  static List<Map<dynamic, dynamic>> foldersList = [];
  static int count = 0;
  static int folderCount = 0;

  VideoFunctions() {
    getVideosList().then((list) {
      videoList = list;
      count = videoList.length;
    });
    getFolderList().then((list) {
      foldersList = list;
      folderCount = foldersList.length;
    });
  }

  static Future<List> getVideosList() async {
    List<MediaFile> videoMediaFileList =
        await FlutterMultiMediaPicker.getVideo();

    videoList = videoMediaFileList;
    count = videoMediaFileList.length;

    return videoMediaFileList;
  }

  static Future<List<Map<dynamic, dynamic>>> getFolderList() async {
    List<MediaFile> videoMediaFileList =
        await FlutterMultiMediaPicker.getVideo();

    videoList = videoMediaFileList;
    count = videoMediaFileList.length;

    List<Map<dynamic, dynamic>> list = getAllFolders(videoMediaFileList, count);

    foldersList = list;
    folderCount = list.length;

    return list;
  }

  static String getFileName(int index, List<MediaFile> videoList) {
    String path = videoList[index].path;
    List<String> file = path.split('/');
    return file[file.length - 1];
  }

  static String getFileNameFromPath(String path) {
    List<String> file = path.split('/');
    return file[file.length - 1];
  }

  static String getFolderName(int index, List<MediaFile> videoList) {
    String path = videoList[index].path;
    List<String> file = path.split('/');
    return file[file.length - 2];
  }

  static String getFilePath(List<MediaFile> videoMediaList, int index) {
    String path = videoMediaList[index].path;
    List<String> file = path.split('/');
    return path.split(file[file.length - 1])[0];
  }

  static int getNoOfVideos(
      List<MediaFile> videoMediaList, String filePath, int count) {
    int c = 0;
    for (int i = 0; i < count; i++) {
      if (filePath == getFilePath(videoMediaList, i)) {
        c++;
      }
    }
    return c;
  }

  static List<Map<dynamic, dynamic>> getAllFolders(
      List<MediaFile> videoMediaList, int count) {
    List<String> foundFolders = [];
    List<Map<dynamic, dynamic>> folders = [];
    // String output="\n";
    for (int i = 0; i < count; i++) {
      String path = getFilePath(videoMediaList, i);
      if (!foundFolders.contains(path)) {
        foundFolders.add(path);
        List<String> p = path.split('/');
        String name = p[p.length - 2];
        int num = getNoOfVideos(videoMediaList, path, count);
        String number = "";
        if (num <= 1) {
          number = num.toString() + " Video";
        } else {
          number = num.toString() + " Videos";
        }
        // output+=name+" ($number)"+'\n';

        var folderMap = new Map();
        folderMap['name'] = name;
        folderMap['number'] = number;
        folderMap['path'] = path;
        folders.add(folderMap);
      }
    }
    // return output;
    return folders;
  }

  // static List<Map<dynamic,dynamic>> getSortedByRecent(List<MediaFile> videoMediaList, int count){
  //   List<Map<dynamic,dynamic>> filesList=[];

  //   for(int i=0;i<count;i++){

  //   }
  // }

  static Future<Uint8List> getVideoThumbnail(String path) async {
    final Uint8List uint8list = await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      maxWidth:
          128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    );
    return uint8list;
  }
}
