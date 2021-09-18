import 'package:flutter/material.dart';

class ResizableItemModel{
  Widget child;
  bool isImage;
  Color color;
  String colorStr;
  Color bgColor;
  String title;
  double height;
  double width;
  double top;
  double left;
  bool isSelected;
  bool isFrame;
  String imagePath;
  String fontFamily;
  ResizableItemModel({
    this.child,
    this.color,
    this.title,
    this.bgColor,
    this.height,
    this.width,
    this.left=0,
    this.top=0,
    this.isSelected,
    this.isFrame = false,
    this.isImage,
    this.imagePath,
    this.colorStr,
    this.fontFamily
  }){
    if(width ==null && height == null){
      if(isImage)
      {
        width = 200;
        height = 200;
      }
      else
      {
        width = 150;
        height = 80;
      }
    }
  }
  ResizableItemModel.fromJson(Map<String, dynamic> json) {
    child = json['child'] as Widget;
    color = json['colorStr']!= "null" &&  json['colorStr']!= null? Color(int.parse(json['colorStr'])):null;
    bgColor = json['bgColor']!= "null" ? Color(int.parse(json['bgColor'])):null;
    title = json['title'];
    height = json['height'] as double;
    width = json['width'] as double;
    top = json['top'] as double;
    left = json['left'] as double;
    isFrame = json['isFrame'] as bool;
    isImage = json['isImage'] as bool;
    imagePath = json['imagePath'];
    colorStr = json['colorStr'];
    fontFamily = json['fontFamily'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['child'] = this.child;
    data['color'] = this.color.toString();
    data['bgColor'] = this.bgColor.toString();
    data['title'] = this.title;
    data['height'] = this.height;
    data['width'] = this.width;
    data['top'] = this.top;
    data['left'] = this.left;
    data['isFrame'] = this.isFrame;
    data['isImage'] = this.isImage;
    data['imagePath'] = this.imagePath;
    data['colorStr'] = this.colorStr;
    data['fontFamily'] = this.fontFamily;
    return data;
}
}