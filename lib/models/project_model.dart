import 'package:get/get.dart';
import 'package:myapp/models/resizable_item_model.dart';

class ProjectModel{
  var layouts = [];
  String title;
  String projectCoverImagePath;
  List<ResizableItemModel> items=[];
  ProjectModel({this.layouts, this.title,this.projectCoverImagePath}){
    for(int i=0;i<layouts.length;i++){
      items.add(layouts[i].resizableItemModel);
    }
  }

  ProjectModel.fromJson(Map<String, dynamic> json){
    title = json["title"];
    projectCoverImagePath = json["projectCoverImagePath"];
    items =json['items'] != null ? (json['items'] as List).map((i) => ResizableItemModel.fromJson(i)).toList() : null;
  }
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['projectCoverImagePath'] = this.projectCoverImagePath;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}