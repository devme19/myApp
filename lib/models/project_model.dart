import 'package:get/get.dart';
import 'package:myapp/models/resizable_item_model.dart';

class ProjectModel{
  var layouts = [];
  String title;
  List<ResizableItemModel> items=[];
  ProjectModel({this.layouts, this.title}){
    for(int i=0;i<layouts.length;i++){
      items.add(layouts[i].resizableItemModel);
    }
  }

  ProjectModel.fromJson(Map<String, dynamic> json){
    title = json["title"];
    items =json['items'] != null ? (json['items'] as List).map((i) => ResizableItemModel.fromJson(i)).toList() : null;
  }
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}