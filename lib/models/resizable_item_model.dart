import 'package:flutter/material.dart';
import 'package:myapp/widgets/resizable_widget.dart';

class ResizableItemModel{
  Widget child;
  ValueChanged<ResizableWidget> deleteItem;
  ValueChanged<ResizableWidget> editItem;
  HSVColor color;
  String title;

  ResizableItemModel(
      {this.child, this.deleteItem, this.editItem, this.color, this.title});
}