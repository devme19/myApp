import 'package:flutter/material.dart';
import 'package:myapp/widgets/resizable_widget.dart';

class ResizableItemModel{
  Widget child;
  ValueChanged<Widget> deleteItem;
  ValueChanged<ResizableWidget> editItem;
  ValueChanged<Widget> bringToFront;
  Color color;
  Color bgColor;
  String title;

  double height;
  double width;
  double top;
  double left;
  ResizableItemModel({
    this.child,
    this.deleteItem,
    this.editItem,
    this.color,
    this.title,
    this.bgColor,
    this.bringToFront,
    this.height=50,
    this.width=100,
    this.left=0,
    this.top=0
  });
}