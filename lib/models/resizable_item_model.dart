import 'package:flutter/material.dart';

class ResizableItemModel{
  Widget child;
  bool isImage;
  Color color;
  Color bgColor;
  String title;
  double height;
  double width;
  double top;
  double left;
  bool isSelected;
  bool isFrame;
  ResizableItemModel({
    this.child,
    this.color,
    this.title,
    this.bgColor,
    this.height=50,
    this.width=100,
    this.left=0,
    this.top=0,
    this.isSelected,
    this.isFrame = false,
    this.isImage
  });
  ResizableItemModel.fromJson(Map<String, dynamic> json) {
    child = json['child'] as Widget;
    color = json['color'] as Color;
    bgColor = json['bgColor'] as Color;
    title = json['title'];
    height = json['height'] as double;
    width = json['width'] as double;
    top = json['top'] as double;
    left = json['left'] as double;
    isFrame = json['isFrame'] as bool;
    isImage = json['isImage'] as bool;
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
    return data;
}
}