import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/home_page_controller.dart';

class HomePage extends GetView<HomePageController> {
  @override
  Widget build(BuildContext context) {
    return
      Obx(()=>Scaffold(
        drawer: Drawer(
          child: ReorderableListView(
            header: Container(
              color: Colors.deepOrangeAccent,
              height: Get.height/6,
            ),
            children: [
              for(int i=0;i<controller.layout.length;i++)
                Card(
                    // color:controller.keys[0].?Colors.grey:Colors.white ,
                    key: ValueKey(controller.layout[i]),
                    child: ListTile(
                      onTap: () {
                         controller.onListTileTap(i);
                        Get.back();
                      },
                      trailing:
                      Container(
                        // color: Colors.grey,
                        width: 80,
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                  onTap: () {
                                    Get.back();
                                    controller.onEditListTile(i);

                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                  )),
                            ),
                            SizedBox(width: 30,),
                            Expanded(
                              child: InkWell(
                                  onTap: () {
                                    controller.onDeleteListTile(i);
                                    Get.back();
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      title: Text(

                        controller.layout[i].resizableItemModel.title ,overflow: TextOverflow.ellipsis,),
                    ))
            ],
            onReorder: reorderData,
          ),
        ),
          appBar: AppBar(),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.save),
                label: 'ذخیره',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'افزودن عکس',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: 'افزودن متن',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'افزودن قاب',
              ),
            ],
            currentIndex: controller.selectedIndex.value,
            selectedItemColor: Colors.amber[800],
            onTap: controller.onMenuTapped,
          ),
          body:
        RepaintBoundary(
          key: controller.globalKey,
          child: Stack(
              children: controller.layout),
        ),
      ));
  }
  void reorderData(int oldIndex, int newIndex){
    if(newIndex>oldIndex){
      newIndex-=1;
    }
    final item =controller.keys.removeAt(oldIndex);
    final widget = controller.layout.removeAt(oldIndex);
    controller.layout.insert(newIndex, widget);
    controller.keys.insert(newIndex, item);
    // if(controller.selectedItemIndex.value != -1)
    //   controller.selectedItemIndex.value = newIndex;
  }

}
