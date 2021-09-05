import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/widgets/resizable_widgett.dart';

class ResizableItemModel{
  Widget child;
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
    this.isFrame = false
  });
}