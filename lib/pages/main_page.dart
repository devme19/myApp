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
                    child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          crossAxisSpacing: 30, maxCrossAxisExtent: 200,
                        ),
                        itemCount: controller.projects.length,
                        itemBuilder: (BuildContext context, int index) {
                          return

                            Stack(
                              children: [
                                InkWell(
                                  onTap: ()=>Get.toNamed(MyAppRoutes.homePage,arguments: controller.projects[index]).then((value) => controller.loadProjects()),
                                  child: Card(
                                  color: Colors.amber,
                                  child: Center(child: Text(controller.projects[index].title,style: TextStyle(color: Colors.purple.shade300,fontWeight: FontWeight.bold),)),
                          ),
                                ),
                                IconButton(onPressed: (){
                                  controller.deleteProject(controller.projects[index].title);
                                }, icon: Icon(Icons.delete,color: Colors.red,size: 50,)),
                              ],
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
