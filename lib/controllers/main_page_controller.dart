import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myapp/models/project_model.dart';

class MainPageController extends GetxController{
  GetStorage box;
  RxList projects=[].obs;

  @override
  void onInit() {
    super.onInit();
    box = GetStorage();
    loadProjects();
  }

  loadProjects(){
    projects.clear();
    for(var item in box.getKeys())
      projects.add(ProjectModel.fromJson(json.decode(box.read(item))));
  }
  deleteProject(String key){
    box.remove(key);
    loadProjects();
  }
}