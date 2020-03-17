import 'package:flutter/foundation.dart';

class NetigmaFile {
  @required
  int fileCode;

  String name;
  String description;
  String fileDate;
  final String fileUrl;
  final String contentType;
  final int contentLenght;
  final String extension;
  final int imageWidth;
  final int imageHeight;
  final String thumbnailUrl;
   String objectName;
   String objectid;

  String tmpFilePath;  
  bool uploaded = true;
  bool hasError = false;


  NetigmaFile(
      {this.fileCode,
      this.name,
      this.fileDate,
      this.fileUrl,
      this.contentType,
      this.contentLenght,
      this.extension,
      this.imageHeight,
      this.imageWidth,
      this.thumbnailUrl,
      this.description,
      this.objectName,
      this.objectid});

  factory NetigmaFile.fromJson(Map<String, dynamic> json) {
    return new NetigmaFile(
      fileCode: json['FileCode'],
      name: json['Name'],
      fileDate: json['FileDate'],
      fileUrl: json['FileUrl'],
      contentType: json['ContentType'],
      contentLenght: json['ContentLenght'],
      extension: json['Extension'],
      imageHeight: json['ImageHeight'],
      imageWidth: json['ImageWidth'],
      thumbnailUrl: json['ThumbnailUrl'],
      description: json['Description'],
      objectName: json['ObjectName'],
      objectid: json['ObjectID'],
    );
 
 
  }
}
