import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/main_page_controller.dart';
import 'package:myapp/navigations/my_app.dart';
class MainPage extends GetView<MainPageController> {
  MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
      
      SafeArea(
        child: Scaffold(
          body: Obx(()=>
            Container(
              padding: EdgeInsets.all(16.0),
              child:

              Column(
                children: [
                 SizedBox(height: 60,),
                  Expanded(
                    child:
                    GridView.builder(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          crossAxisSpacing: 30, maxCrossAxisExtent: 200,
                          mainAxisSpacing: 30
                        ),
                        itemCount: controller.projects.length,
                        itemBuilder: (BuildContext context, int index) {
                          return

                            Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.all(Radius.circular(30))
                              ),
                              child: Stack(
                                children: [
                                  InkWell(
                                    onTap: ()=>Get.toNamed(MyAppRoutes.homePage,arguments: controller.projects[index]).then((value) => controller.loadProjects()),
                                    child:

                                    Container(
                                      width: 220,
                                        // height:400,
                                        child:
                                        ClipRRect(
                                            borderRadius: BorderRadius.circular(30),
                                            child: Image.file(File(controller.projects[index].projectCoverImagePath),fit: BoxFit.cover,)))
                                    // Card(
                                    // color: Colors.amber,
                                    // child: Center(child: Text(controller.projects[index].title,style: TextStyle(color: Colors.purple.shade300,fontWeight: FontWeight.bold),)),),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child:
                                    Container(
                                        padding: const EdgeInsets.all(16.0),
                                        decoration:BoxDecoration(
                                          color:Colors.grey.withOpacity(0.4),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(30),
                                            bottomRight: Radius.circular(30)
                                          )
                                        ),
                                        child:
                                        Row(
                                          mainAxisAlignment:MainAxisAlignment.center,
                                          children: [
                                            Text(controller.projects[index].title,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                          ],
                                        )),
                                  ),
                                  Container(
                                    margin:EdgeInsets.only(right: 8.0,top: 8.0),
                                    decoration:BoxDecoration(
                                        color:Colors.grey.withOpacity(0.4),
                                        borderRadius: BorderRadius.all(Radius.circular(16),)
                                    ),
                                    child: IconButton(onPressed: (){
                                      controller.deleteProject(controller.projects[index].title);
                                    }, icon: Icon(Icons.delete,color: Colors.red,size: 30,)),
                                  ),
                                ],
                              ),
                            );
                        }
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Get.toNamed(MyAppRoutes.homePage).then((value) {
                        controller.loadProjects();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text('ایجاد پروژه جدید'),
                    ),
                  ),
                ],
              )
            )
    ),
        ),
      );
  }
}
